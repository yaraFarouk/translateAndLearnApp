import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

part 'gemini_feedback_state.dart';

class GeminiFeedbackCubit extends Cubit<GeminiFeedbackState> {
  GeminiFeedbackCubit(this.model) : super(GeminiFeedbackInitial());
  final GenerativeModel model;
  String languageFrom = 'English';
  String languageTo = 'English';
  String lastText = '';

  Future<void> getFeedback(
      String language, List<Map<String, dynamic>> chartData) async {
    try {
      emit(GeminiFeedbackLoading());

      String prompt =
          "You are a language learning app for $language language and you take this chart data $chartData and give the user a feedback about his progress and then give him an advice to improve his skills in the language. Try to make your feedback motivating and friendly and summarized and make all the words with the same font size";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final translatedText = response.text!;

      emit(GeminiFeedbackSuccess(translatedText));
    } catch (e) {
      emit(GeminiFeedbackError("Error occurred during get feedback"));
    }
  }

  void resetFeedback() {
    emit(GeminiFeedbackInitial());
  }
}
