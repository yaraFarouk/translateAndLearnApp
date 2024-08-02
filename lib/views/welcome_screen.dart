import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/language_selection_screen.dart';
import 'package:translate_and_learn_app/views/sign_up_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageIndex = 0;
  final LocalizationService _localizationService = LocalizationService();
  Map<String, String> localizationData = {};

  @override
  void initState() {
    super.initState();
    fetchLocalizationData();
  }

  Future<void> fetchLocalizationData() async {
    localizationData['welcome'] = await _localizationService.fetchFromFirestore(
        'Welcome To Translate And Learn App',
        'Welcome To Translate And Learn App');
    localizationData['learnWords'] = await _localizationService
        .fetchFromFirestore('Learn New Words', 'Learn New Words');
    localizationData['trackProgress'] = await _localizationService
        .fetchFromFirestore('Track Your Progress', 'Track Your Progress');
    localizationData['welcomeBody'] =
        await _localizationService.fetchFromFirestore(
            'translate > get new words > learn',
            'translate > get new words > learn');
    localizationData['learnWordsBody'] =
        await _localizationService.fetchFromFirestore(
            'Learn new words every day', 'Learn new words every day');
    localizationData['trackProgressBody'] =
        await _localizationService.fetchFromFirestore(
            'Quiz and get your progress', 'Quiz and get your progress');

    setState(() {}); // Update the UI after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: localizationData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                IntroductionScreen(
                  key: introKey,
                  pages: [
                    buildPageViewModel(
                      context,
                      title: localizationData['welcome'] ??
                          'Welcome To Translate And Learn App',
                      body: localizationData['welcomeBody'] ??
                          'translate > get new words > learn',
                      imagePath: "assets/images/welcom_logo.png",
                    ),
                    buildPageViewModel(
                      context,
                      title:
                          localizationData['learnWords'] ?? 'Learn New Words',
                      body: localizationData['learnWordsBody'] ??
                          'Learn new words every day',
                      imagePath: "assets/images/learn_logo.png",
                    ),
                    buildPageViewModel(
                      context,
                      title: localizationData['trackProgress'] ??
                          'Track Your Progress',
                      body: localizationData['trackProgressBody'] ??
                          'Quiz and get your progress',
                      imagePath: "assets/images/analysis_logo.png",
                    ),
                  ],
                  onDone: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('hasSeenWelcome', true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                  onSkip: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('hasSeenWelcome', true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      );
                    },
                    child: Text("Skip", style: TextStyle(fontSize: 18.sp)),
                  ),
                ),
                if (currentPageIndex != 2) // Check if it's not the last page
                  Positioned(
                    bottom: 40.h,
                    right: 20.w,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            introKey.currentState?.next();
                          },
                          label: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          heroTag: 'next',
                          backgroundColor: kAppBarColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: const BorderSide(
                                color: kAppBarColor, width: 2.0),
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
                            introKey.currentState?.previous();
                          },
                          label: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          heroTag: 'back',
                          backgroundColor: kAppBarColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: const BorderSide(
                                color: kAppBarColor, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (currentPageIndex == 2) // Check if it's the last page
                  Positioned(
                    bottom: 40.h,
                    right: 20.w,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('hasSeenWelcome', true);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()),
                            );
                          },
                          label: const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          heroTag: 'done',
                          backgroundColor: kAppBarColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: const BorderSide(
                                color: kAppBarColor, width: 2.0),
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
                fontFamily: kFont,
              ),
              textAlign: TextAlign.center,
            ),
          if (!isLastPage) SizedBox(height: 10.0.h),
          if (!isLastPage)
            Text(
              body,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontFamily: kFont,
              ),
              textAlign: TextAlign.center,
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
