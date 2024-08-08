import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/quiz_page.dart';

class QuizButton extends StatefulWidget {
  const QuizButton({super.key, required this.words, required this.language});
  final List<WordDetailsModel> words;
  final String language;

  @override
  State<QuizButton> createState() => _QuizButtonState();
}

class _QuizButtonState extends State<QuizButton> {
  void _showNoWordsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Words Available'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final LocalizationService _localizationService = LocalizationService();
  late Future<String> _studyTranslation;

  @override
  void initState() {
    super.initState();
    _studyTranslation = _localizationService.fetchFromFirestore('QUIZ', 'QUIZ');
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
          final studyTranslation = snapshot.data ?? 'QUIZ';

          return SizedBox(
            width: 70.w,
            height: 80.h,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kAppBarColor, width: 2.0.w),
                borderRadius: BorderRadius.circular(40.0.r),
                color: kAppBarColor,
              ),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  if (widget.words.isEmpty) {
                    _showNoWordsDialog(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          words: widget.words,
                          language: widget.language,
                        ),
                      ),
                    );
                  }
                },
                child: Material(
                  color: kPrimaryColor,
                  elevation: 4,
                  shadowColor: kAppBarColor,
                  shape: const CircleBorder(),
                  child: Center(
                    child: Text(
                      studyTranslation,
                      style: TextStyle(
                          fontFamily: 'CookieCrisp',
                          color: kAppBarColor,
                          fontSize: 24.sp),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
