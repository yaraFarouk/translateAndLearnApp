import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/widgets/flip_transition.dart';
import 'package:translate_and_learn_app/widgets/study_back_card.dart';
import 'package:translate_and_learn_app/widgets/study_front_card.dart';

class StudyWordCard extends StatelessWidget {
  const StudyWordCard(
      {super.key,
      required this.isFlipped,
      required this.index,
      required this.cardColor,
      this.onTap,
      required this.filteredWord,
      required this.reversedWord,
      required this.languageFrom,
      required this.languageTo});
  final bool isFlipped;
  final int index;
  final Color cardColor;
  final Function()? onTap;
  final String filteredWord;
  final String reversedWord;
  final String languageFrom, languageTo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        height: 150,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FlipTransition(
                animation: animation,
                child: child,
              );
            },
            child: isFlipped
                ? StudyBackCard(
                    context: context,
                    index: index,
                    cardColor: cardColor,
                    word: filteredWord,
                    languageFrom: languageFrom,
                    languageTo: languageTo,
                    isFlipped: isFlipped,
                    reversedWord: reversedWord)
                : StudyFrontCard(
                    context: context,
                    index: index,
                    cardColor: cardColor,
                    filteredWord: filteredWord),
          ),
        ),
      ),
    );
  }
}
