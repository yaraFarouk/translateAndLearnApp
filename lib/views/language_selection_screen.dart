import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'home_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? selectedLanguage;
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
    'Korean'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 100.0.h,
                ),
              ),
            ),
            Spacer(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kAppBarColor,
                  borderRadius: BorderRadius.circular(40.0),
                  border: Border.all(
                    color: kAppBarColor,
                    width: 2.0,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: kAppBarColor,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 30,
                    elevation: 16,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    isExpanded: true,
                    value: selectedLanguage,
                    hint: const Text(
                      'Select Language',
                      style: TextStyle(color: Colors.white),
                    ),
                    items: languages.map((String value) {
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
                    await prefs.setBool('hasSeenWelcome', true);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
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
                    borderRadius: BorderRadius.circular(40.0),
                    side: const BorderSide(
                      color: kTranslatorcardColor,
                      width: 2.0,
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
            Image.asset(
              "assets/images/select.png",
            )
          ],
        ),
      ),
    );
  }
}
