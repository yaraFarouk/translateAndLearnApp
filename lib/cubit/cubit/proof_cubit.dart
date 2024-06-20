import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'package:translate_and_learn_app/views/words_list_view.dart';

part 'proof_state.dart';

class ProofCubit extends Cubit<ProofState> {
  final GenerativeModel model;

  ProofCubit(this.model) : super(ProofInitial());

  Future<void> getAnswers(String language, String word, String question) async {
    try {
      String prompt =
          "you are correct a quiz for $language language I will provide you with the question and the answer of the question. I want you to provide me with a simple explanation why this answer is the correct one.the question: $question, the answer: $word. display the proof only without any additinal words";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final responseText = response.text!;

      emit(ProofGenerated(responseText));
    } catch (e) {
      emit(ProofError(e.toString()));
    }
  }
}
