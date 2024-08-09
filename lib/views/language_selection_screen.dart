import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/views/welcome_screen.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  int selectedLanguageIndex = 0;
  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Polish',
    'Turkish',
    'Russian',
    'Dutch',
    'Korean',
  ];

  final Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Chinese': 'zh',
    'Japanese': 'ja',
    'Polish': 'pl',
    'Turkish': 'tr',
    'Russian': 'ru',
    'Dutch': 'nl',
    'Korean': 'ko',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 200.h,
              ),
              Text(
                'Please select your native language:',
                style: TextStyle(fontSize: 18.sp, fontFamily: kFont),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.all(40),
                width: 200.w,
                height: 150.h,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 2.w,
                  ),
                ),
                child: CupertinoPicker(
                  backgroundColor: kPrimaryColor,
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedLanguageIndex = index;
                    });
                  },
                  children: languages.map((String language) {
                    return Center(
                      child: Text(
                        language,
                        style: TextStyle(color: Colors.black, fontSize: 18.sp),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String selectedLanguage = languages[selectedLanguageIndex];
                  await prefs.setString('nativeLanguage', selectedLanguage);
                  await prefs.setString(
                      'nativeLanguageCode', languageCodes[selectedLanguage]!);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTranslatorcardColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  textStyle: TextStyle(fontSize: 20.sp),
                  side: BorderSide(color: kGeminiColor, width: 2.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.r),
                    side: BorderSide(
                      color: kTranslatorcardColor,
                      width: 2.w,
                    ),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: kAppBarColor,
                    fontFamily: kFont,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40.h),
                child: Image.asset(
                  "assets/images/select.png",
                  height: 200.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
