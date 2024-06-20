// cubit/quiz_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final GenerativeModel model;

  QuizCubit(this.model) : super(QuizInitial());

  Future<void> generateQuestion(String language, String word) async {
    try {
      String prompt =
          "You are a language learning app that creates quiz questions. Generate a question in $language language where the answer is the word ($word). Only display the question without its answer and without any additional words.if the question is complete make in the space place of the missed word dots to show that";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final responseText = response.text!;
      emit(QuizQuestionGenerated(responseText));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
