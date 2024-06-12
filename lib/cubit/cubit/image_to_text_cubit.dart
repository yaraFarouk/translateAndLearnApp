import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

part 'image_to_text_state.dart';

class ImageToTextCubit extends Cubit<ImageToTextState> {
  ImageToTextCubit(this.imageModel) : super(ImageToTextInitial());
  final GenerativeModel imageModel;
  Future<void> fetchTextFromImage(File image) async {
    emit(ImageToTextLoading());
    try {
      final imageBytes = await image.readAsBytes();
      final prompt = TextPart(
          "Extract the text from this image and display it without any additions");
      final imageParts = [DataPart('image/jpeg', imageBytes)];
      final content = [
        Content.multi([prompt, ...imageParts])
      ];
      final response = await imageModel.generateContent(content);
      if (response.text != null) {
        emit(ImageToTextSuccess(response.text!));
      } else {
        emit(ImageToTextError('Failed to extract text'));
      }
    } catch (e) {
      emit(ImageToTextError('Failed to extract text'));
    }
  }
}
