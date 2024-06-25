import 'dart:convert';

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

      String prompt =
          "you are a dictionary that gives a definition and translation and meaning and example for a given word translate it from $language to English. Make the response json data because I want to access every string for definition and meaning and example like a map in my flutter app. Make the response contains only the json code without any additional data. The given word is '$word'";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception("Response text is null");
      }

      // Clean the response by removing unwanted characters like ```json
      String cleanedResponse =
          response.text!.replaceAll(RegExp(r'^```json|```$'), '').trim();

      print("Cleaned response: $cleanedResponse");

      // Parse the cleaned JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(cleanedResponse);

      emit(DictionarySuccess(jsonResponse['meaning'],
          jsonResponse['definition'], jsonResponse['example']));
    } catch (e) {
      print("Error: $e");
      emit(DictionaryError("Error occurred during dictionary: $e"));
    }
  }
}
