import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/cubit/cubit/words_translate_cubit.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/views/word_details_screen.dart';

class StudyBackCard extends StatelessWidget {
  const StudyBackCard(
      {super.key,
      required this.context,
      required this.index,
      required this.cardColor,
      required this.word,
      required this.languageFrom,
      required this.languageTo,
      required this.isFlipped,
      required this.reversedWord});
  final BuildContext context;
  final int index;
  final Color cardColor;
  final String word;
  final String languageFrom;
  final String languageTo;
  final bool isFlipped;
  final WordDetailsModel reversedWord;
  @override
  Widget build(BuildContext context) {
    if (languageFrom == languageTo) {
      return Card(
        key: const ValueKey(true),
        color: cardColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      word,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 33,
                        fontFamily: 'CookieCrisp',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordDetailsScreen(
                          word: reversedWord,
                          language: languageTo,
                        ),
                      ),
                    );
                  },
                  child: const Text('Study'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        key: const ValueKey(true),
        color: cardColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      reversedWord.translation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 33,
                        fontFamily: 'CookieCrisp',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordDetailsScreen(
                          word: reversedWord,
                          language: languageTo,
                        ),
                      ),
                    );
                  },
                  child: const Text('Study'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
