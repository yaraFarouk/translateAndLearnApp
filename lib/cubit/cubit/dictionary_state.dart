part of 'dictionary_cubit.dart';

@immutable
abstract class DictionaryState {}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionarySuccess extends DictionaryState {
  final String meaning;
  final String definition;
  final String examples;

  DictionarySuccess(this.meaning, this.definition, this.examples);
}

class DictionaryError extends DictionaryState {
  final String error;

  DictionaryError(this.error);
}
