import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:translate_and_learn_app/views/home_view.dart';

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const apiKey = 'AIzaSyD2WmRS8KtpHKYi3DvMj_r1C_0-MBXmlPc';

  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  runApp(TranslateAndLearnApp(
    model: model,
  ));
}

class TranslateAndLearnApp extends StatelessWidget {
  const TranslateAndLearnApp({super.key, required this.model});
  final GenerativeModel model;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GenerativeModel>.value(value: model),
        BlocProvider(
          create: (context) => GeminiApiCubit(
            model,
          ),
        ),
      ],
      child: MaterialApp(
        home: const HomePage(),
      ),
    );
  }
}
