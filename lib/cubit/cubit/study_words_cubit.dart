import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:characters/characters.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';

part 'study_words_state.dart';

class StudyWordsCubit extends Cubit<StudyWordsState> {
  final GenerativeModel model;
  LocalizationService localizationService = LocalizationService();

  StudyWordsCubit(this.model) : super(StudyWordsState());

  void updateLanguageTo(String language) {
    emit(state.copyWith(languageTo: language));
  }

  Future<void> addNewWords(String language, String text) async {
    emit(state.copyWith(isLoading: true)); // Set loading state to true

    final updatedWords = Map<String, Set<String>>.from(state.studyWords);
    final updatedWordDetails =
        Map<String, List<WordDetailsModel>>.from(state.wordDetails);

    final words = await _getWords(language, text);

    if (!updatedWords.containsKey(language)) {
      updatedWords[language] = <String>{};
    }

    if (!updatedWordDetails.containsKey(language)) {
      updatedWordDetails[language] = [];
    }

    final newWordDetails = <WordDetailsModel>[];

    String userLanguage =
        await localizationService.fetchFromFirestore("locale", "en");

    for (var word in words) {
      final cleanedWord = _cleanWord(word);

      if (cleanedWord.isNotEmpty &&
          !updatedWords[language]!.contains(cleanedWord)) {
        try {
          final wordDetails =
              await _getWordDetails(cleanedWord, language, userLanguage);

          updatedWords[language]!.add(cleanedWord);
          newWordDetails.add(wordDetails);
        } catch (e) {
          print("Error fetching word details for $cleanedWord: $e");
        }
      }
    }

    updatedWordDetails[language]!.addAll(newWordDetails);
    emit(state.copyWith(
      studyWords: updatedWords,
      wordDetails: updatedWordDetails,
      isLoading: false, // Set loading state to false after loading
    ));
  }

  void deleteWord(String language, String word) {
    final updatedWords = Map<String, Set<String>>.from(state.studyWords);
    final updatedWordDetails =
        Map<String, List<WordDetailsModel>>.from(state.wordDetails);

    if (updatedWords.containsKey(language)) {
      updatedWords[language]!.remove(word);
      if (updatedWords[language]!.isEmpty) {
        updatedWords.remove(language);
      }

      updatedWordDetails[language]
          ?.removeWhere((detail) => detail.word == word);
      emit(state.copyWith(
          studyWords: updatedWords, wordDetails: updatedWordDetails));
    }
  }

  String _cleanWord(String word) {
    final characters = Characters(word);
    final cleanedCharacters = characters.where((char) =>
        RegExp(r"^[\p{L}\p{M}'-]+$", unicode: true).hasMatch(char.toString()));
    return cleanedCharacters.isEmpty ? '' : cleanedCharacters.toString();
  }

  Future<List<String>> _getWords(String language, String text) async {
    String prompt =
        "split this $language text into individual $language words separated by space considering that it is $language language: ($text) ";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final responseText = response.text!;
    final words = responseText.split(RegExp(r'\s+'));
    return words;
  }

  Future<WordDetailsModel> _getWordDetails(
      String word, String languageFrom, String languageTo) async {
    String prompt = """
    you are a dictionary that provide a translation and meaning and definition and examples for a given word
    {
      "translation": "You are a translator App that provide the most common translation word for a word from $languageFrom to $languageTo. Translate this word ($word), display the translation only without any adds or definitions.",
      "meaning": "Provide a clear and concise meaning for the $languageFrom word '$word' in language '$languageTo'. Ensure the meaning is in the context of its most common usage. The response should be in language($languageTo). Provide the response briefly and in normal font size.",
      "definition": "Provide a clear and concise definition for the $languageFrom word '$word' in language '$languageTo'. Ensure the definition is in the context of its most common usage. The response should be in language($languageTo). Provide the response briefly and in normal font size.",
      "examples": "Provide examples of sentences using the $languageFrom word '$word' in language '$languageTo'. Ensure the examples are in the context of its most common usage. Provide the response briefly and in an ordered format: each example should be followed by its translation in language($languageTo) below the example like that 1. I am a student endl > I am a student."
    }
    provide the response to be a json code type map<string,string> because I will use it in my flutter app provide the json code without any additional data
    """;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text == null) {
      throw Exception("Response text is null");
    }

    String cleanedResponse =
        response.text!.replaceAll(RegExp(r'^```json|```$'), '').trim();

    final Map<String, dynamic> jsonResponse = jsonDecode(cleanedResponse);

    return WordDetailsModel(
      word: word,
      translation: jsonResponse['translation'],
      languageofWord: languageFrom,
      languageoftranslation: languageTo,
      meaning: jsonResponse['meaning'],
      definition: jsonResponse['definition'],
      examples: jsonResponse['examples'],
    );
  }
}
