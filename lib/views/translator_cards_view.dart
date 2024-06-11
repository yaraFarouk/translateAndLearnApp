import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/widgets/card_widget.dart';
import 'package:translate_and_learn_app/widgets/microphon_translator_card.dart';
import 'package:translate_and_learn_app/widgets/select_voice_camera_text.dart';
import 'package:translate_and_learn_app/widgets/translator_card.dart';

class TranslatorcardsView extends StatelessWidget {
  const TranslatorcardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TranslatorCardCubit(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          BlocBuilder<TranslatorCardCubit, TranslatorCardState>(
            builder: (context, state) {
              if (state is TranslatorCardMicrophoneSelected) {
                return const MicrophonTranslatorCard(
                  color: kTranslatorcardColor,
                  hint: 'Text will appear here',
                );
              }
              return const TranslatorCard(
                hint: 'Tap to enter text',
                color: kTranslatorcardColor,
              );
            },
          ),
          BlocBuilder<GeminiApiCubit, GeminiApiState>(
            builder: (context, state) {
              String translatedText = 'Translation will appear here';
              if (state is GeminiApiSuccess) {
                translatedText = state.response;
              } else if (state is GeminiApiError) {
                translatedText = state.error;
              }
              return Languagecard(
                text: translatedText,
                color: kTranslationCardColor,
              );
            },
          ),
          const SizedBox(height: 30),
          const ThreeFloatingButtons(),
        ],
      ),
    );
  }
}
