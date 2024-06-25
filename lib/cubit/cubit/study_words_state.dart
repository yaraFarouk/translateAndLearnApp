part of 'study_words_cubit.dart';

class StudyWordsState {
  final Map<String, Set<String>> studyWords;
  final Map<String, List<WordDetailsModel>> wordDetails;
  final String languageTo;
  final bool isLoading;

  StudyWordsState({
    this.studyWords = const {},
    this.wordDetails = const {},
    this.languageTo = 'English',
    this.isLoading = false,
  });

  StudyWordsState copyWith({
    Map<String, Set<String>>? studyWords,
    Map<String, List<WordDetailsModel>>? wordDetails,
    String? languageTo,
    bool? isLoading,
  }) {
    return StudyWordsState(
      studyWords: studyWords ?? this.studyWords,
      wordDetails: wordDetails ?? this.wordDetails,
      languageTo: languageTo ?? this.languageTo,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
