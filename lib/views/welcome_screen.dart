import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/views/language_selection_screen.dart';
import 'home_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IntroductionScreen(
            key: introKey,
            pages: [
              buildPageViewModel(
                context,
                title: "Welcome To Translate And Learn App",
                body: "translate -> get new words -> learn",
                imagePath: "assets/images/welcom_logo.png",
              ),
              buildPageViewModel(
                context,
                title: "Learn New Words",
                body: "Learn new words every day",
                imagePath: "assets/images/learn_logo.png",
              ),
              buildPageViewModel(
                context,
                title: "Track Your Progress",
                body: "Quiz and get your progress",
                imagePath: "assets/images/analysis_logo.png",
              ),
              buildPageViewModel(
                context,
                title: "Get Started",
                body: "",
                imagePath: "assets/images/get_start.png",
                isLastPage: true,
              ),
            ],
            onDone: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hasSeenWelcome', true);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LanguageSelectionPage(),
                ),
              );
            },
            onSkip: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hasSeenWelcome', true);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LanguageSelectionPage(),
                ),
              );
            },
            showSkipButton: false,
            showNextButton: false,
            showDoneButton: false,
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            onChange: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
          ),
          Positioned(
            top: 40.h,
            right: 20.w,
            child: TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasSeenWelcome', true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              },
              child: Text("Skip", style: TextStyle(fontSize: 18.sp)),
            ),
          ),
          if (currentPageIndex != 3) // Check if it's not the last page
            Positioned(
              bottom: 40.h,
              right: 20.w,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      // Access the IntroductionScreen controller using the GlobalKey
                      introKey.currentState?.next();
                    },
                    label: const Icon(
                      Icons.arrow_forward, // Use arrow forward icon for next
                      color: Colors.white,
                    ),
                    heroTag: 'next', // Unique hero tag for the NEXT button
                    backgroundColor: kAppBarColor, // Match the background color
                    elevation: 4, // Match the elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40.0), // Match the shape
                      side: const BorderSide(
                          color: kAppBarColor, width: 2.0), // Match the border
                    ),
                  ),
                ),
              ),
            ),
          if (currentPageIndex > 0) // Check if it's not the first page
            Positioned(
              bottom: 40.h,
              left: 20.w,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      // Access the IntroductionScreen controller using the GlobalKey
                      introKey.currentState?.previous();
                    },
                    label: const Icon(
                      Icons.arrow_back, // Use arrow back icon for back
                      color: Colors.white,
                    ),
                    heroTag: 'back', // Unique hero tag for the BACK button
                    backgroundColor: kAppBarColor, // Match the background color
                    elevation: 4, // Match the elevation
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(40.0), // Match the shape
                      side: const BorderSide(
                          color: kAppBarColor, width: 2.0), // Match the border
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PageViewModel buildPageViewModel(BuildContext context,
      {required String title,
      required String body,
      required String imagePath,
      bool isLastPage = false}) {
    return PageViewModel(
      titleWidget: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Image.asset(
          "assets/images/logo.png",
          height: 80.0.h,
        ),
      ),
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isLastPage) Image.asset(imagePath, height: 400.h),
          if (!isLastPage)
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          if (!isLastPage) SizedBox(height: 10.0.h),
          if (!isLastPage)
            Text(
              body,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          if (isLastPage) Image.asset(imagePath, height: 400.h),
          if (isLastPage)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('hasSeenWelcome', true);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTranslatorcardColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  textStyle: TextStyle(fontSize: 20.sp),
                ),
                child: const Text(
                  'Let\'s Go',
                  style: TextStyle(
                    color: kAppBarColor,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
        ],
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
        bodyFlex: 2,
        imageFlex: 3,
      ),
    );
  }
}
