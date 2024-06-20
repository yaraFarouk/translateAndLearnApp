// cubit/answers_state.dart

part of 'answers_cubit.dart';

@immutable
abstract class AnswersState {}

class AnswersInitial extends AnswersState {}

class AnswersGenerated extends AnswersState {
  final List<String> answers;

  AnswersGenerated(this.answers);
}

class AnswersError extends AnswersState {
  final String message;

  AnswersError(this.message);
}
