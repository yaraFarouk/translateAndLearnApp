import 'package:flutter/material.dart';

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
  final String filteredWord;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(false),
      color: cardColor,
      child: Center(
        child: Text(
          filteredWord,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 33, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
