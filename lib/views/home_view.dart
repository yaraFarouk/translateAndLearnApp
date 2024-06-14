import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/views/study_view.dart';
import 'package:translate_and_learn_app/views/translator_cards_view.dart';
import 'package:translate_and_learn_app/widgets/bottom_app_bar.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TranslatorCardCubit(),
        ),
        BlocProvider(
          create: (context) => StudyWordsCubit(),
        )
      ],
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 70),
              CustomAppTopBar(
                title: 'Translate & learn',
                icon: Icons.search,
              ),
              SizedBox(height: 20),
              Expanded(
                child:
                    _currentIndex == 0 ? TranslatorcardsView() : StudyScreen(),
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