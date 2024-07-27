import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/models/quiz_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final GenerativeModel model;

  QuizCubit(this.model) : super(QuizInitial());

  Future<void> generateQuestion(String language, String word) async {
    try {
      String prompt =
          "You are a language learning app that creates quiz questions. Generate a question in $language language where the answer is the word ($word). You can only just display the question without its answer and without any additional words. if the question is complete make in the space place of the missed word dots to show that and provide four choices between them for the correct answer is the word '$word' and provide a proof why the word $word is the correct answer for this question. provide the response as JSON data like this { 'question': , 'choice1' :, 'choice2': ,'choice3': , 'choice4':, 'proof':,} provide the json data as map<string,string>";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception("Response text is null");
      }

      String cleanedResponse =
          response.text!.replaceAll(RegExp(r'^```json|```$'), '').trim();

      final Map<String, dynamic> jsonResponse = jsonDecode(cleanedResponse);

      emit(QuizQuestionGenerated(QuizModel(
        question: jsonResponse['question'],
        choice1: jsonResponse['choice1'],
        choice2: jsonResponse['choice2'],
        choice3: jsonResponse['choice3'],
        choice4: jsonResponse['choice4'],
        proof: jsonResponse['proof'],
      )));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  Future<void> updateProgress(
      String language, String word, bool isCorrect) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final trackProgressRef = FirebaseFirestore.instance
          .collection('track_progress')
          .doc(uid)
          .collection(language);

      final allWordsRef = FirebaseFirestore.instance
          .collection('all_words')
          .doc(uid)
          .collection(language);

      final now = DateTime.now();
      final date = '${now.year}-${now.month}-${now.day}';

      final docRef = trackProgressRef.doc(date);

      try {
        final doc = await docRef.get();
        if (doc.exists) {
          final currentScore = doc.data()?['score'] ?? 0;
          final answeredWords =
              Map<String, bool>.from(doc.data()?['answeredWords'] ?? {});

          if (isCorrect) {
            if (!answeredWords.containsKey(word) || !answeredWords[word]!) {
              await docRef.update({
                'score': currentScore + 1,
                'answeredWords': {...answeredWords, word: true}
              });
            }
          } else {
            if (answeredWords.containsKey(word) && answeredWords[word]!) {
              await docRef.update({
                'score': currentScore - 1,
                'answeredWords': {...answeredWords, word: false}
              });
            }
          }
        } else {
          await docRef.set({
            'score': isCorrect ? 1 : -1,
            'answeredWords': {word: isCorrect}
          });
        }

        // Update the all words collection
        final allWordsDocRef = allWordsRef.doc(word);
        await allWordsDocRef.set({'isCorrect': isCorrect, 'lastUpdated': now},
            SetOptions(merge: true));
      } catch (e) {
        emit(QuizError(e.toString()));
      }
    }
  }

  Future<bool> hasAnsweredCorrectlyBefore(String language, String word) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final trackProgressRef = FirebaseFirestore.instance
          .collection('track_progress')
          .doc(uid)
          .collection(language);

      final now = DateTime.now();
      final date = '${now.year}-${now.month}-${now.day}';

      final docRef = trackProgressRef.doc(date);
      final doc = await docRef.get();

      if (doc.exists) {
        final answeredWords =
            Map<String, bool>.from(doc.data()?['answeredWords'] ?? {});
        return answeredWords.containsKey(word) && answeredWords[word]!;
      }
    }

    return false;
  }
}
