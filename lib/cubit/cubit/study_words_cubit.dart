import 'package:bloc/bloc.dart';

part 'study_words_state.dart';

class StudyWordsCubit extends Cubit<StudyWordsState> {
  StudyWordsCubit() : super(StudyWordsState());

  void updateLanguageTo(String language) {
    emit(state.copyWith(languageTo: language));
  }

  void addNewWords(String language, String text) {
    final words = text.split(RegExp(r'\s+')); // Split the text into words
    final updatedWords = Map<String, Set<String>>.from(state.studyWords);

    if (!updatedWords.containsKey(language)) {
      updatedWords[language] = <String>{};
    }

    for (var word in words) {
      if (word.isNotEmpty && !updatedWords[language]!.contains(word)) {
        updatedWords[language]!.add(word);
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
}
