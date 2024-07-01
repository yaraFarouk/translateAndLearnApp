import 'package:bloc/bloc.dart';
import 'package:characters/characters.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import 'package:translate_and_learn_app/models/word_details_model.dart';

part 'word_details_state.dart';

class WordDetailsCubit extends Cubit<WordDetailsState> {
  final GenerativeModel model;
  String languageTo;

  WordDetailsCubit(this.model, this.languageTo) : super(WordDetailsInitial());

  Future<void> addNewWords(String language, String text) async {
    try {
      emit(WordDetailsLoading());
      final updatedWordDetails = <WordDetailsModel>[];

      // Get words from text based on language
      final words = await _getWords(language, text);

      for (var word in words) {
        // Clean the word using the characters package
        final cleanedWord = _cleanWord(word);

        if (cleanedWord.isNotEmpty) {
          // Get details for each word
          final wordDetails = await _getWordDetails(cleanedWord, language);

          // Translate each word
          final translation = await _translateWord(cleanedWord, language);

          updatedWordDetails.add(
            WordDetailsModel(
              word: cleanedWord,
              translation: translation,
              languageofWord: language,
              languageoftranslation: languageTo,
              meaning: wordDetails.meaning,
              definition: wordDetails.definition,
              examples: wordDetails.examples,
            ),
          );
        }
      }

      emit(WordDetailsSuccess(updatedWordDetails));
    } catch (e) {
      print('Error occurred while adding new words: $e');
      emit(WordDetailsError("Error occurred while adding new words: $e"));
    }
  }

  Future<void> getWordDetails(String word, String language) async {
    try {
      emit(WordDetailsLoading());

      // Get details for the word
      final wordDetails = await _getWordDetails(word, language);

      // Translate the word
      final translation = await _translateWord(word, language);

      final wordDetailsModel = WordDetailsModel(
        word: word,
        translation: translation,
        languageofWord: language,
        languageoftranslation: languageTo,
        meaning: wordDetails.meaning,
        definition: wordDetails.definition,
        examples: wordDetails.examples,
      );

      emit(WordDetailsSuccess([wordDetailsModel]));
    } catch (e) {
      emit(WordDetailsError("Error occurred while fetching word details"));
    }
  }

  void deleteWord(String word) {
    if (state is WordDetailsSuccess) {
      final currentState = state as WordDetailsSuccess;
      final updatedWordDetails =
          List<WordDetailsModel>.from(currentState.wordDetails)
            ..removeWhere((element) => element.word == word);

      emit(WordDetailsSuccess(updatedWordDetails));
    }
  }

  Future<List<String>> _getWords(String language, String text) async {
    String prompt =
        "split this $language text into individual $language words separated by space: ($text)";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final responseText = response.text!;
    final words = responseText.split(RegExp(r'\s+'));
    return words;
  }

  String _cleanWord(String word) {
    final characters = Characters(word);
    final cleanedCharacters = characters.where((char) =>
        RegExp(r"^[\p{L}\p{M}'-]+$", unicode: true).hasMatch(char.toString()));
    return cleanedCharacters.isEmpty ? '' : cleanedCharacters.toString();
  }

  Future<WordDetailsModel> _getWordDetails(String word, String language) async {
    try {
      String meaningPrompt =
          "You are a dictionary. Provide a clear and concise meaning for the word '$word' in language '$language'. Ensure the meaning is in the context of its most common usage. Provide the response briefly and in normal font size.";
      String definitionPrompt =
          "You are a dictionary. Provide a clear and concise definition for the word '$word' in language '$language'. Ensure the definition is in the context of its most common usage. Provide the response briefly and in normal font size.";
      String examplesPrompt =
          "You are a dictionary. Provide examples of sentences using the word '$word' in language '$language'. Ensure the examples are in the context of its most common usage. Provide the response briefly and in an ordered format.";

      final meaningContent = [Content.text(meaningPrompt)];
      final definitionContent = [Content.text(definitionPrompt)];
      final examplesContent = [Content.text(examplesPrompt)];

      final meaningResponse = await model.generateContent(meaningContent);
      final definitionResponse = await model.generateContent(definitionContent);
      final examplesResponse = await model.generateContent(examplesContent);

      return WordDetailsModel(
        word: word,
        translation: '',
        languageofWord: language,
        languageoftranslation: '',
        meaning: meaningResponse.text!,
        definition: definitionResponse.text!,
        examples: examplesResponse.text!,
      );
    } catch (e) {
      throw Exception("Error occurred during dictionary lookup");
    }
  }

  Future<String> _translateWord(String word, String languageFrom) async {
    try {
      String prompt =
          "Translate the word '$word' from $languageFrom to $languageTo. Provide only the translation without any additional information.";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text!;
    } catch (e) {
      throw Exception("Error occurred during translation");
    }
  }

  void updateLanguageTo(String language) {
    // Update the target translation language
    languageTo = language;
  }
}
