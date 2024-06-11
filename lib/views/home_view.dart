import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/views/translator_cards_view.dart';
import 'package:translate_and_learn_app/widgets/bottom_app_bar.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TranslatorCardCubit(),
        ),
      ],
      child: const Scaffold(
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
              Expanded(child: TranslatorcardsView()),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomAppBar(),
      ),
    );
  }
}
