import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/gemini_chat_cubit.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/chat_screen.dart';
import 'package:flutter/cupertino.dart';

class StartChatScreen extends StatefulWidget {
  const StartChatScreen({super.key});

  @override
  _StartChatScreenState createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  int? selectedLanguageIndex;
  bool isLoading = false;

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
    return BlocListener<GeminiChatCubit, GeminiChatState>(
      listener: (context, state) {
        if (state is GeminiChatInitial) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          )
              .then((_) {
            // Ensure that loading state is reset when coming back from ChatScreen
            setState(() {
              isLoading = false;
            });
          });
        } else if (state is GeminiChatError) {
          setState(() {
            isLoading = false; // Stop loading on error
          });
        }
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: LocalizationService().fetchFromFirestore(
                  'Which language do you want to learn with Gemini?',
                  'Which language do you want to learn with Gemini?',
                ),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              SizedBox(height: 20.h),
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
                    if (index != null) {
                      context
                          .read<GeminiChatCubit>()
                          .updateLanguageTo(languageCodes[languages[index]]!);
                    }
                  },
                  children: languages.map((String language) {
                    return Center(
                      child: FutureBuilder<String>(
                          future: LocalizationService()
                              .fetchFromFirestore(language, language),
                          builder: (context, snapshot) {
                            return Text(
                              language,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.sp),
                            );
                          }),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h),
              isLoading
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: () {
                        if (selectedLanguageIndex != null) {
                          setState(() {
                            isLoading = true;
                          });
                          context.read<GeminiChatCubit>().resetTranslation();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: FutureBuilder<String>(
                                future:
                                    LocalizationService().fetchFromFirestore(
                                  'Please select a language first.',
                                  'Please select a language first.',
                                ),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data ?? '');
                                },
                              ),
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: kGeminiColor, width: 2.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 12.h),
                      ),
                      child: FutureBuilder<String>(
                        future: LocalizationService().fetchFromFirestore(
                          'Start Chat with Gemini',
                          'Start Chat with Gemini',
                        ),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? '',
                            style:
                                TextStyle(color: kAppBarColor, fontSize: 18.sp),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
