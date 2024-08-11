import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/word_details_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudyBackCard extends StatefulWidget {
  const StudyBackCard({
    super.key,
    required this.context,
    required this.index,
    required this.cardColor,
    required this.word,
    required this.isFlipped,
    required this.reversedWord,
    required this.wordID,
    required this.language,
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
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _studyTranslation =
        _localizationService.fetchFromFirestore('Study', 'Study');
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(
      languageCodes[widget.reversedWord.languageofWord] ?? 'en_EN',
    );
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _studyTranslation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final studyTranslation = snapshot.data ?? 'Study';

          return Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: kGeminiColor,
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
                                  language: widget.language,
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
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.volumeHigh),
                  onPressed: () {
                    _speak(widget.reversedWord.translation);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
