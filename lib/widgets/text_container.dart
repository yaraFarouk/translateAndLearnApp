import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({super.key, required this.title, required this.content});
  final String title;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kTranslationCardColor),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: kPurpil,
            ),
          ),
          const SizedBox(height: 8.0),
          content,
        ],
      ),
    );
    ;
  }
}
