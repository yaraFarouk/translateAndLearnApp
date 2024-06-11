part of 'gemini_api_cubit.dart';

@immutable
abstract class GeminiApiState {}

class GeminiApiInitial extends GeminiApiState {}

class GeminiApiLoading extends GeminiApiState {}

class GeminiApiSuccess extends GeminiApiState {
  final String response;
  GeminiApiSuccess(this.response);
}

class GeminiApiError extends GeminiApiState {
  final String error;
  GeminiApiError(this.error);
}
