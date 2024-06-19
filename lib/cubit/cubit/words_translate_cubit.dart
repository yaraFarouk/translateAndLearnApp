import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'dart:async'; // Import for Timer

part 'words_translate_state.dart';

class WordsTranslateCubit extends Cubit<WordsTranslateState> {
  final GenerativeModel model;
  // Debounce timer

  WordsTranslateCubit(this.model) : super(WordsTranslateInitial());

  Future<void> translateText(
      String word, String languageFrom, String languageTo) async {
    // Debounce text input to handle rapid typing and deleting

    try {
      emit(WordsTranslateLoading());
      String prompt =
          "You are a translator App that provide the most comman translation word for a word from $languageFrom to $languageTo translate this word ($word), display the translation only without any adds or definitions";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final translatedText = response.text!;

      emit(WordsTranslateSuccess(translatedText));
    } catch (e) {
      emit(WordsTranslateError("Error occurred during translation"));
    }
  }

  void resetTranslation() {
    emit(WordsTranslateInitial());
  }
}
