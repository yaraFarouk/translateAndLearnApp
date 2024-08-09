import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudyFrontCard extends StatelessWidget {
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

  void _playSound() {
    // Add your sound playing logic here
    print('Playing sound for ${filteredWord.word}');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          key: const ValueKey(false),
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: kGeminiColor, // Set the border color
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              filteredWord.word,
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
            onPressed: _playSound,
          ),
        ),
      ],
    );
  }
}
