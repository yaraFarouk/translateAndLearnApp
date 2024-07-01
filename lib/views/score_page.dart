import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';

class ScorePage extends StatelessWidget {
  final int score;
  final int totalScore;

  const ScorePage({super.key, required this.score, required this.totalScore});

  @override
  Widget build(BuildContext context) {
    double percentage = (score / totalScore) * 100;

    String getMessage() {
      if (percentage >= 85) {
        return 'Excellent, keep going!';
      } else if (percentage >= 75) {
        return 'Very good, the next time will be better!';
      } else if (percentage >= 65) {
        return 'Good, but need more practice.';
      } else {
        return 'Hmm.., you need more practice.';
      }
    }

    Color getContainerColor() {
      if (percentage >= 85) {
        return const Color.fromARGB(255, 61, 199, 66);
      } else if (percentage >= 75) {
        return const Color.fromARGB(255, 60, 133, 193);
      } else if (percentage >= 65) {
        return const Color.fromARGB(255, 205, 188, 41);
      } else {
        return const Color.fromARGB(255, 203, 83, 83);
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Image.asset(
                "assets/images/logo.png",
                height: 100.h,
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: kTranslationCardColor,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your Score: $score/$totalScore',
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 175, 55, 196)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      getMessage(),
                      style: TextStyle(
                          fontSize: 20.sp, color: getContainerColor()),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'RETURN',
                  style: TextStyle(fontFamily: 'CookieCrisp'),
                ),
                icon: const Icon(Icons.arrow_back),
                heroTag: 'returnBtn',
                backgroundColor: kAppBarColor,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: const BorderSide(color: kAppBarColor, width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
