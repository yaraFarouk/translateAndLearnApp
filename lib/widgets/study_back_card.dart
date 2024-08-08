import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/word_details_screen.dart';

class StudyBackCard extends StatefulWidget {
  StudyBackCard({
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
  final String language;

  @override
  State<StudyBackCard> createState() => _StudyBackCardState();
}

class _StudyBackCardState extends State<StudyBackCard> {
  final LocalizationService _localizationService = LocalizationService();
  late Future<String> _studyTranslation;

  @override
  void initState() {
    super.initState();
    _studyTranslation =
        _localizationService.fetchFromFirestore('Study', 'Study');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _studyTranslation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Handle error
        } else {
          final studyTranslation = snapshot.data ?? 'Study';

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: kGeminiColor, // Set the border color
                width: 1.5,
              ),
            ),
            key: const ValueKey(true),
            color: widget.cardColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.reversedWord.translation,
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
                              wordId: widget.wordID,
                              language: widget
                                  .language, // Pass the language parameter
                            ),
                          ),
                        );
                      },
                      child: Text(studyTranslation),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
