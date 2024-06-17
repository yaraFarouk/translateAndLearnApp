part of 'words_translate_cubit.dart';

@immutable
abstract class WordsTranslateState {}

class WordsTranslateInitial extends WordsTranslateState {}

class WordsTranslateLoading extends WordsTranslateState {}

class WordsTranslateSuccess extends WordsTranslateState {
  final String response;
  WordsTranslateSuccess(this.response);
}

class WordsTranslateError extends WordsTranslateState {
  final String error;
  WordsTranslateError(this.error);
}
