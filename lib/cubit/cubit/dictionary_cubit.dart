import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:localization/localization.dart';
import 'package:meta/meta.dart';
part 'dictionary_state.dart';

class DictionaryCubit extends Cubit<DictionaryState> {
  DictionaryCubit(this.model) : super(DictionaryInitial());
  final GenerativeModel model;

  Future<void> getWordDetails(String word, String language) async {
    try {
      emit(DictionaryLoading());

      String meaningPrompt =
          "You are a dictionary. Provide a clear and concise meaning for the word '$word' in language '$language'. Ensure the meaning is in the context of its most common usage. The response should be in language(${"@@locale".i18n()}). Provide the response briefly and in normal font size.";
      String definitionPrompt =
          "You are a dictionary. Provide a clear and concise definition for the word '$word' in language '$language'. Ensure the definition is in the context of its most common usage. The response should be in language(${"@@locale".i18n()}). Provide the response briefly and in normal font size.";
      String examplesPrompt =
          "You are a dictionary. Provide examples of sentences using the word '$word' in language '$language'. Ensure the examples are in the context of its most common usage. Provide the response briefly and in an ordered format: each example should be followed by its translation in language(${"@@locale".i18n()}) below the example like that 1.i am student endl >i am student.";

      final meaningContent = [Content.text(meaningPrompt)];
      final definitionContent = [Content.text(definitionPrompt)];
      final examplesContent = [Content.text(examplesPrompt)];

      final meaningResponse = model.generateContent(meaningContent);
      final definitionResponse = model.generateContent(definitionContent);
      final examplesResponse = model.generateContent(examplesContent);

      final results = await Future.wait(
          [meaningResponse, definitionResponse, examplesResponse]);

      final meaning = results[0].text!;
      final definition = results[1].text!;
      final examples = results[2].text!;

      emit(DictionarySuccess(meaning, definition, examples));
    } catch (e) {
      emit(DictionaryError("Error occurred during dictionary"));
    }
  }
}
