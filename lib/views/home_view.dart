import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/views/GeminiView.dart';
import 'package:translate_and_learn_app/views/favorites_screen.dart';
import 'package:translate_and_learn_app/views/study_view.dart';
import 'package:translate_and_learn_app/views/track_progress_screen.dart';
import 'package:translate_and_learn_app/views/translator_cards_view.dart';
import 'package:translate_and_learn_app/widgets/bottom_app_bar.dart';
import 'package:translate_and_learn_app/views/standing_screen.dart'; // Import StandingScreen

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
        BlocProvider(
          create: (context) => FavoritesCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(FontAwesomeIcons.circleUser,
                        color: kGeminiColor), // Set icon color to purple
                    onPressed: () {},
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 80.h,
                      ),
                    ),
                  ),
                  const Spacer(), // Pushes the icon to the far right
                  IconButton(
                    icon: Icon(FontAwesomeIcons.rankingStar,
                        color: kGeminiColor), // Set icon color to purple
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserRankingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: const [
                    TranslatorcardsView(),
                    StudyScreen(),
                    TrackProgressPage(),
                    StartChatScreen(),
                    FavoritesScreen(),
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
