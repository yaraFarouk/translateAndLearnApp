part of 'study_words_cubit.dart';

class StudyWordsState {
  final String languageTo;
  final bool isLoading;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  StudyWordsState({
    this.languageTo = 'English',
    this.isLoading = false,
    this.lastDocument,
    this.hasMore = true,
  });

  StudyWordsState copyWith({
    String? languageTo,
    bool? isLoading,
    DocumentSnapshot? lastDocument,
    bool? hasMore,
  }) {
    return StudyWordsState(
      languageTo: languageTo ?? this.languageTo,
      isLoading: isLoading ?? this.isLoading,
      lastDocument: lastDocument ?? this.lastDocument,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
