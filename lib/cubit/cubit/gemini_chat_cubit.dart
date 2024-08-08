import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:translate_and_learn_app/services/localization_service.dart';
part 'gemini_chat_state.dart';

class GeminiChatCubit extends Cubit<GeminiChatState> {
  final GenerativeModel model;
  LocalizationService localizationService = LocalizationService();
  String languageFrom = 'English';
  String languageTo = 'English';

  Timer? _debounce; // Debounce timer

  GeminiChatCubit(this.model) : super(const GeminiChatInitial([]));

  void updateLanguageTo(String language) {
    languageTo = language;
  }

  Future<void> translateText(String text) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        // Add user's message to the state
        final updatedMessages = List<Message>.from(state.messages)
          ..add(Message(text: text, isUserMessage: true));
        emit(GeminiChatLoading(updatedMessages));

        // Replace newlines and create the translation prompt
        text = text.replaceAll('\n', ' ');
        String userLanguage =
            await localizationService.fetchFromFirestore("locale", "en");
        String prompt =
            "you are a chat bot in a language learning app the native language of the user is $userLanguage and the language he wants to learn is $languageTo and his message is: $text";

        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        final translatedText = response.text!;

        // Add Gemini's response to the state
        emit(GeminiChatSuccess([
          ...updatedMessages,
          Message(text: translatedText, isUserMessage: false)
        ]));
      } catch (e) {
        emit(GeminiChatError(
            "Error occurred during translation", state.messages));
      }
    });
  }

  Future<void> resetTranslation() async {
    try {
      // Notify the model about the reset without updating the state
      const prompt = "The user has reset the chat.";
      final content = [Content.text(prompt)];
      await model.generateContent(content);
    } catch (e) {}

    emit(const GeminiChatInitial([]));
  }

  void deleteMessage(int index) {
    final updatedMessages = List<Message>.from(state.messages)..removeAt(index);
    emit(GeminiChatSuccess(updatedMessages));
    emit(const GeminiChatInitial([]));
  }

  void editMessage(int index, String newText) {
    final updatedMessages = List<Message>.from(state.messages);
    final oldMessage = updatedMessages[index];

    // Update user's message
    updatedMessages[index] = oldMessage.copyWith(text: newText);

    // Update corresponding response if exists
    if (oldMessage.responseIndex != null) {
      final responseIndex = oldMessage.responseIndex!;
      updatedMessages.removeAt(responseIndex);
      translateText(newText);
    } else {
      emit(GeminiChatSuccess(updatedMessages));
    }
  }

  void copyMessage(int index) {
    final message = state.messages[index];
    // Here you can use Clipboard.setData to copy the message text
    // Clipboard.setData(ClipboardData(text: message.text));
    // Since copying doesn't change the state, no need to emit a new state
  }

  @override
  Future<void> close() {
    _debounce?.cancel(); // Cancel any debounce timer on cubit close
    return super.close();
  }
}
