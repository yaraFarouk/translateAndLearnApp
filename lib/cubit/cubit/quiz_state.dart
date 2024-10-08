// cubit/quiz_state.dart

part of 'quiz_cubit.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizQuestionGenerated extends QuizState {
  final QuizModel quizModel;

  QuizQuestionGenerated(this.quizModel);
}

class QuizFinished extends QuizState {
  final int score;
  final int totalQuestions;

  QuizFinished(this.score, this.totalQuestions);
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}
