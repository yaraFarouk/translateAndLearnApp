import 'package:bloc/bloc.dart';
import 'package:characters/characters.dart';
import 'package:jieba_flutter/analysis/jieba_segmenter.dart';

part 'study_words_state.dart';

class StudyWordsCubit extends Cubit<StudyWordsState> {
  StudyWordsCubit() : super(StudyWordsState());

  void updateLanguageTo(String language) {
    emit(state.copyWith(languageTo: language));
  }

  Future<void> addNewWords(String language, String text) async {
    final updatedWords = Map<String, Set<String>>.from(state.studyWords);

    // Get words from text based on language
    final words = await _getWords(language, text);

    // Ensure the language entry exists in the state
    if (!updatedWords.containsKey(language)) {
      updatedWords[language] = <String>{};
    }

    // Loop through each word
    for (var word in words) {
      // Clean the word using the characters package
      final cleanedWord = _cleanWord(word);

      // Add the cleaned word to the study words if it's not empty
      if (cleanedWord.isNotEmpty) {
        updatedWords[language]!.add(cleanedWord);
      }
    }

    emit(state.copyWith(studyWords: updatedWords));
  }

  void deleteWord(String language, String word) {
    final updatedWords = Map<String, Set<String>>.from(state.studyWords);
    if (updatedWords.containsKey(language)) {
      updatedWords[language]!.remove(word);
      if (updatedWords[language]!.isEmpty) {
        updatedWords.remove(language);
      }
      emit(state.copyWith(studyWords: updatedWords));
    }
  }

  // Helper function to clean a word of unwanted characters
  String _cleanWord(String word) {
    // Use RegExp to match letters, apostrophes, and dashes
    final characters = Characters(word);
    final cleanedCharacters = characters.where((char) =>
        RegExp(r"^[\p{L}\p{M}'-]+$", unicode: true).hasMatch(char.toString()));
    return cleanedCharacters.isEmpty ? '' : cleanedCharacters.toString();
  }

  // Helper function to get words based on language
  Future<List<String>> _getWords(String language, String text) async {
    if (language == 'Japanese') {
      return _segmentJapanese(text);
    } else if (language == 'Chinese') {
      return await _segmentChinese(text);
    } else {
      return _segmentLatin(text);
    }
  }

  // Placeholder for Japanese word segmentation
  List<String> _segmentJapanese(String text) {
    return text.split('');
  }

  // Function for Chinese word segmentation
  Future<List<String>> _segmentChinese(String text) async {
    await JiebaSegmenter.init();
    var seg = JiebaSegmenter();
    final segments = seg.process(text, SegMode.INDEX);
    return segments.map((segment) => segment.word).toList();
  }

  List<String> _segmentLatin(String text) {
    return text.split(RegExp(r'\s+'));
  }
}
