// cubit/answers_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

part 'answers_state.dart';

class AnswersCubit extends Cubit<AnswersState> {
  final GenerativeModel model;

  AnswersCubit(this.model) : super(AnswersInitial());

  Future<void> getAnswers(String language, String word, String question) async {
    try {
      String prompt =
          "you are a language learning app that provides quizzes for new words in $language language, now this is the question: $question and the answer is ($word), make four choices between them the correct answer ($word). display the choices in one line with spaces between them and display the choices only without any brackets or additional words";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final responseText = response.text!;
      final words = responseText.split(RegExp(r'\s+')).toList();
      emit(AnswersGenerated(words));
    } catch (e) {
      emit(AnswersError(e.toString()));
    }
  }
}
