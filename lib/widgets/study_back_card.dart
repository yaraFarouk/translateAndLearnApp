import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/views/word_details_screen.dart';

class StudyBackCard extends StatelessWidget {
  const StudyBackCard({
    super.key,
    required this.context,
    required this.index,
    required this.cardColor,
    required this.word,
    required this.isFlipped,
    required this.reversedWord,
    required this.wordID,
    required this.language, // Add language parameter
  });

  final BuildContext context;
  final int index;
  final Color cardColor;
  final String word;
  final bool isFlipped;
  final WordDetailsModel reversedWord;
  final String wordID;
  final String language; // Add language parameter

  @override
  Widget build(BuildContext context) {
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
                        wordId: wordID,
                        language: language, // Pass the language parameter
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
