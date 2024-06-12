import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

part 'gemini_api_state.dart';

class GeminiApiCubit extends Cubit<GeminiApiState> {
  final GenerativeModel model;
  String languageFrom = 'English';
  String languageTo = 'English';
  String lastText = '';
  GeminiApiCubit(this.model) : super(GeminiApiInitial());

  void updateLanguageFrom(String language) {
    languageFrom = language;
    if (lastText.isNotEmpty) {
      translateText(lastText); // Trigger translation when language changes
    }
  }

  void updateLanguageTo(String language) {
    languageTo = language;
    if (lastText.isNotEmpty) {
      translateText(lastText); // Trigger translation when language changes
    }
  }

  Future<void> translateText(String text) async {
    if (text.isEmpty) {
      lastText = '';
      emit(GeminiApiInitial());
      return;
    }
    try {
      emit(GeminiApiLoading());
      lastText = text;
      // Split the input text into smaller chunks (e.g., sentences)
      text = text.replaceAll('\n', ' ');
      String prompt =
          "You are a translator App from $languageFrom to $languageTo translate this sentence or word ($text), display the translation only"; // Split by period (can adjust based on your needs)

      // Process each sentence separately
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final translatedText =
          response.text!; // Combine sentences into a single text

      emit(GeminiApiSuccess(translatedText));
    } catch (e) {
      emit(GeminiApiError("Loading"));
    }
  }
}
