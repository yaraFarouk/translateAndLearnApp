import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/cubit/cubit/image_to_text_cubit.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:translate_and_learn_app/views/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const apiKey = 'AIzaSyD2WmRS8KtpHKYi3DvMj_r1C_0-MBXmlPc';

  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final imageModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final bool hasSeenWelcome = await checkWelcomeScreenSeen();

  runApp(TranslateAndLearnApp(
    model: model,
    imageModel: imageModel,
    hasSeenWelcome: hasSeenWelcome,
  ));
}

Future<bool> checkWelcomeScreenSeen() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasSeenWelcome') ?? false;
}

class TranslateAndLearnApp extends StatelessWidget {
  const TranslateAndLearnApp({
    super.key,
    required this.model,
    required this.imageModel,
    required this.hasSeenWelcome,
  });

  final GenerativeModel model;
  final GenerativeModel imageModel;
  final bool hasSeenWelcome;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812), // Adjust the design size as needed
        minTextAdapt: true,
        builder: (context, child) => MultiProvider(
              providers: [
                Provider<GenerativeModel>.value(value: model),
                BlocProvider(
                  create: (context) => GeminiApiCubit(model),
                ),
                Provider<GenerativeModel>.value(value: imageModel),
                BlocProvider(
                  create: (context) => ImageToTextCubit(imageModel),
                ),
              ],
              child: MaterialApp(
                home: const OnboardingScreen(),
              ),
            ));
  }
}
//