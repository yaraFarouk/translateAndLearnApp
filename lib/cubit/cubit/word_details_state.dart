part of 'word_details_cubit.dart';

@immutable
abstract class WordDetailsState {}

class WordDetailsInitial extends WordDetailsState {}

class WordDetailsLoading extends WordDetailsState {}

class WordDetailsError extends WordDetailsState {
  final String message;

  WordDetailsError(this.message);
}

class WordDetailsSuccess extends WordDetailsState {
  final List<WordDetailsModel> wordDetails;

  WordDetailsSuccess(this.wordDetails);
}
