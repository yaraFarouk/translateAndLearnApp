import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';

class WordDetailsCard extends StatelessWidget {
  final WordDetailsModel wordDetails;

  const WordDetailsCard({super.key, required this.wordDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(wordDetails.word),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Translation: ${wordDetails.translation}'),
            Text('Meaning: ${wordDetails.meaning}'),
            Text('Definition: ${wordDetails.definition}'),
            Text('Examples: ${wordDetails.examples}'),
          ],
        ),
      ),
    );
  }
}
