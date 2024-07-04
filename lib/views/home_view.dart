import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/views/GeminiView.dart';
import 'package:translate_and_learn_app/views/study_view.dart';
import 'package:translate_and_learn_app/views/translator_cards_view.dart';
import 'package:translate_and_learn_app/widgets/bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final splittingModel =
      GenerativeModel(model: 'gemini-1.5-flash', apiKey: kAPIKEY);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TranslatorCardCubit(),
        ),
        BlocProvider(
          create: (context) => StudyWordsCubit(splittingModel),
        ),
      ],
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
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
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: const [
                    TranslatorcardsView(),
                    StudyScreen(),
                    StartChatScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomAppBar(
          currentIndex: _currentIndex,
          onItemTapped: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
