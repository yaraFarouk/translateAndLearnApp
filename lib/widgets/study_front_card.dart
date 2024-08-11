import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudyFrontCard extends StatefulWidget {
  const StudyFrontCard({
    super.key,
    required this.context,
    required this.index,
    required this.cardColor,
    required this.filteredWord,
  });

  final BuildContext context;
  final int index;
  final Color cardColor;
  final WordDetailsModel filteredWord;

  @override
  State<StudyFrontCard> createState() => _StudyFrontCardState();
}

class _StudyFrontCardState extends State<StudyFrontCard> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(
      languageCodes[widget.filteredWord.languageoftranslation] ?? 'en_EN',
    );
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          key: const ValueKey(false),
          color: widget.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: kGeminiColor, // Set the border color
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              widget.filteredWord.word,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 33,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
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
              _speak(widget.filteredWord.word);
            },
          ),
        ),
      ],
    );
  }
}
