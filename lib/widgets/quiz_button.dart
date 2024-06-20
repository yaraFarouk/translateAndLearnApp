import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/views/quiz_page.dart';

class QuizButton extends StatelessWidget {
  const QuizButton({super.key, required this.words, required this.language});
  final List<String> words;
  final String language;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kAppBarColor, width: 2.0),
          borderRadius: BorderRadius.circular(40.0),
          color: kAppBarColor,
        ),
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizPage(
                  words: words,
                  language: language,
                ),
              ),
            );
          },
          child: const Material(
            color: kPrimaryColor,
            elevation: 4,
            shadowColor: kAppBarColor,
            shape: CircleBorder(),
            child: Center(
              child: Text(
                'QUIZ',
                style: TextStyle(
                    fontFamily: 'CookieCrisp',
                    color: kAppBarColor,
                    fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
