import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';

class StudyFrontCard extends StatelessWidget {
  const StudyFrontCard(
      {super.key,
      required this.context,
      required this.index,
      required this.cardColor,
      required this.filteredWord});
  final BuildContext context;
  final int index;
  final Color cardColor;
  final WordDetailsModel filteredWord;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const ValueKey(false),
      color: cardColor,
      child: Center(
        child: Text(
          filteredWord.word,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 33, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
