import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'dart:async'; // Import for Timer

part 'gemini_api_state.dart';

class GeminiApiCubit extends Cubit<GeminiApiState> {
  final GenerativeModel model;
  String languageFrom = 'English';
  String languageTo = 'English';
  String lastText = '';
  Timer? _debounce; // Debounce timer

  GeminiApiCubit(this.model) : super(GeminiApiInitial());

  void updateLanguageFrom(String language) {
    languageFrom = language;
    if (lastText.isNotEmpty) {
      _debounce?.cancel(); // Cancel any ongoing debounce timer
      _debounce = Timer(const Duration(milliseconds: 500), () {
        translateText(lastText);
      }); // Trigger translation after debounce
    }
  }

  void updateLanguageTo(String language) {
    languageTo = language;
    if (lastText.isNotEmpty) {
      _debounce?.cancel(); // Cancel any ongoing debounce timer
      _debounce = Timer(const Duration(milliseconds: 500), () {
        translateText(lastText);
      }); // Trigger translation after debounce
    }
  }

  Future<void> translateText(String text) async {
    if (text.isEmpty) {
      lastText = '';
      emit(GeminiApiInitial());
      return;
    }

    // Debounce text input to handle rapid typing and deleting
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        emit(GeminiApiLoading());
        lastText = text;

        // Replace newlines and create the translation prompt
        text = text.replaceAll('\n', ' ');
        String prompt =
            "You are a translator App from $languageFrom to $languageTo translate this sentence or word ($text), display the translation only without any adds or definitions and if there is no input display translation will appear here";

        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        final translatedText = response.text!;

        emit(GeminiApiSuccess(translatedText));
      } catch (e) {
        emit(GeminiApiError("Error occurred during translation"));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel(); // Cancel any debounce timer on cubit close
    return super.close();
  }
}
