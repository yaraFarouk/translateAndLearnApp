part of 'study_words_cubit.dart';

class StudyWordsState {
  final Map<String, Set<String>> studyWords;
  final Map<String, List<WordDetailsModel>> wordDetails;
  final String languageTo;

  StudyWordsState({
    this.studyWords = const {},
    this.wordDetails = const {},
    this.languageTo = 'English',
  });

  StudyWordsState copyWith({
    Map<String, Set<String>>? studyWords,
    Map<String, List<WordDetailsModel>>? wordDetails,
    String? languageTo,
  }) {
    return StudyWordsState(
      studyWords: studyWords ?? this.studyWords,
      wordDetails: wordDetails ?? this.wordDetails,
      languageTo: languageTo ?? this.languageTo,
    );
  }
}
