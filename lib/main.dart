import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/cubit/cubit/gemini_chat_cubit.dart';
import 'package:translate_and_learn_app/cubit/cubit/image_to_text_cubit.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:translate_and_learn_app/views/home_view.dart';
import 'package:translate_and_learn_app/views/language_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Gemini API
  const apiKey = 'AIzaSyBcjYQMdIZpKvmLvCsPIc15kFRxqCA0KNQ';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final imageModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  final geminiChatModel =
      GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  final bool hasSeenWelcome = await checkWelcomeScreenSeen();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('nativeLanguageCode');
  Locale? initialLocale;
  if (languageCode != null) {
    initialLocale = Locale(languageCode);
  }

  /// Useless (From Documentation)
  /// await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(TranslateAndLearnApp(
    model: model,
    imageModel: imageModel,
    hasSeenWelcome: hasSeenWelcome,
    initialLocale: initialLocale,
    geminiChatModel: geminiChatModel,
    routeObserver: routeObserver,
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
    this.initialLocale,
    required this.geminiChatModel,
    required this.routeObserver,
  });
  final RouteObserver<ModalRoute> routeObserver;
  final GenerativeModel model;
  final GenerativeModel imageModel;
  final GenerativeModel geminiChatModel;
  final bool hasSeenWelcome;
  final Locale? initialLocale;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812), // Adjust the design size as needed
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
                Provider<GenerativeModel>.value(value: geminiChatModel),
                BlocProvider(
                  create: (context) => GeminiChatCubit(geminiChatModel),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: hasSeenWelcome
                    ? const HomePage()
                    : const LanguageSelectionPage(),
              ),
            ));
  }
}
