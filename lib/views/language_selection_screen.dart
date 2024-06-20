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
  String? selectedLanguage;
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
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const Spacer(),
            Center(
              child: Text(
                'Please select your native language:',
                style: TextStyle(fontSize: 18.sp, fontFamily: 'CookieCrisp'),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Container(
                width: 200.w,
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: kAppBarColor,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(
                    color: kAppBarColor,
                    width: 2.w,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(8.r),
                    dropdownColor: kAppBarColor,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 30.sp,
                    elevation: 16,
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    isExpanded: true,
                    value: selectedLanguage,
                    hint: const Text(
                      'Select Language',
                      style: TextStyle(color: Colors.white),
                    ),
                    items: languageCodes.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLanguage = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedLanguage != null) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('nativeLanguage', selectedLanguage!);
                    await prefs.setString(
                        'nativeLanguageCode', languageCodes[selectedLanguage]!);
                    await prefs.setBool('hasSeenWelcome', true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a language'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTranslatorcardColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  textStyle: TextStyle(fontSize: 20.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.r),
                    side: BorderSide(
                      color: kTranslatorcardColor,
                      width: 2.w,
                    ),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: kAppBarColor,
                    fontFamily: 'CookieCrisp',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 18.w),
              child: Image.asset(
                "assets/images/select.png",
                height: 350.h,
              ),
            )
          ],
        ),
      ),
    );
  }
}
