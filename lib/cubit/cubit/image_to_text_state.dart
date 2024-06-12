part of 'image_to_text_cubit.dart';

@immutable
sealed class ImageToTextState {}

final class ImageToTextInitial extends ImageToTextState {}

class ImageToTextLoading extends ImageToTextState {}

class ImageToTextSuccess extends ImageToTextState {
  final String response;
  ImageToTextSuccess(this.response);
}

class ImageToTextError extends ImageToTextState {
  final String error;
  ImageToTextError(this.error);
}
