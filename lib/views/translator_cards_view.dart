import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/widgets/camera_translator_card.dart';
import 'package:translate_and_learn_app/widgets/card_widget.dart';
import 'package:translate_and_learn_app/widgets/microphon_translator_card.dart';
import 'package:translate_and_learn_app/widgets/select_voice_camera_text.dart';
import 'package:translate_and_learn_app/widgets/translator_card.dart';
// Import the updated Languagecard widget

class TranslatorcardsView extends StatelessWidget {
  const TranslatorcardsView({super.key});

  Future<String> getLocalizedText(String key, String fallback) async {
    LocalizationService localizationService = LocalizationService();
    return await localizationService.fetchFromFirestore(key, fallback);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TranslatorCardCubit(),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FutureBuilder(
          future: Future.wait([
            getLocalizedText('tap_to_enter_text', 'Tap to enter text'),
            getLocalizedText(
                'translation_will_appear_here', 'Translation will appear here'),
            getLocalizedText('text_will_appear_here', 'Text will appear here'),
          ]),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading localizations'));
            } else {
              List<String> localizedTexts = snapshot.data!;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  BlocBuilder<TranslatorCardCubit, TranslatorCardState>(
                    builder: (context, state) {
                      final geminiApiCubit = context.read<GeminiApiCubit>();
                      if (state is TranslatorCardMicrophoneSelected) {
                        geminiApiCubit.resetTranslation();
                        return MicrophonTranslatorCard(
                          color: kTranslatorcardColor,
                          hint: localizedTexts[2],
                        );
                      } else if (state is TranslatorCardCameraSelected) {
                        geminiApiCubit.resetTranslation();
                        return CameraTranslatorCard(
                            color: kTranslatorcardColor, hint: localizedTexts[2]);
                      }
                      geminiApiCubit.resetTranslation();
                      return TranslatorCard(
                        hint: localizedTexts[0],
                        color: kTranslatorcardColor,
                      );
                    },
                  ),
                  BlocBuilder<GeminiApiCubit, GeminiApiState>(
                    builder: (context, state) {
                      String translatedText = "";
                      if (state is GeminiApiSuccess) {
                        translatedText = state.response;
                      } else if (state is GeminiApiError) {
                        translatedText = state.error;
                      }
                      return Languagecard(
                        translatedText:
                            translatedText, // The actual translated text
                        hintText: localizedTexts[1], // The hint text
                        color: kTranslationCardColor,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  const ThreeFloatingButtons(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
