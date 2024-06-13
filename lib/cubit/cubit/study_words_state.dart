part of 'study_words_cubit.dart';

class StudyWordsState {
  final Map<String, Set<String>> studyWords;
  final String languageTo;

  StudyWordsState({
    this.studyWords = const {},
    this.languageTo = 'English',
  });

  StudyWordsState copyWith({
    Map<String, Set<String>>? studyWords,
    String? languageTo,
  }) {
    return StudyWordsState(
      studyWords: studyWords ?? this.studyWords,
      languageTo: languageTo ?? this.languageTo,
    );
  }
}
