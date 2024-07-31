part of 'gemini_feedback_cubit.dart';

@immutable
sealed class GeminiFeedbackState {}

final class GeminiFeedbackInitial extends GeminiFeedbackState {}

class GeminiFeedbackLoading extends GeminiFeedbackState {}

class GeminiFeedbackSuccess extends GeminiFeedbackState {
  final String response;
  GeminiFeedbackSuccess(this.response);
}

class GeminiFeedbackError extends GeminiFeedbackState {
  final String error;
  GeminiFeedbackError(this.error);
}
