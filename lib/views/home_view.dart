import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/views/study_view.dart';
import 'package:translate_and_learn_app/views/translator_cards_view.dart';
import 'package:translate_and_learn_app/widgets/bottom_app_bar.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart';
import 'package:localization/localization.dart';

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
              const SizedBox(height: 70),
              CustomAppTopBar(
                title: 'translate_and_learn_title'.i18n(),
                icon: Icons.search,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    const TranslatorcardsView(),
                    StudyScreen(),
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
