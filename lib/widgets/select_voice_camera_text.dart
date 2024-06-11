import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/translator_card_cubit.dart';
import 'package:translate_and_learn_app/widgets/floating_button.dart';

class ThreeFloatingButtons extends StatelessWidget {
  const ThreeFloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslatorCardCubit, TranslatorCardState>(
      builder: (context, state) {
        Color textButtonColor = kPrimaryColor;
        Color microphoneButtonColor = kPrimaryColor;
        Color cameraButtonColor = kPrimaryColor;

        if (state is TranslatorCardTextSelected) {
          textButtonColor = kOrange;
        } else if (state is TranslatorCardMicrophoneSelected) {
          microphoneButtonColor = kOrange;
        } else if (state is TranslatorCardCameraSelected) {
          cameraButtonColor = kOrange;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingButton(
                color: textButtonColor,
                icon: FontAwesomeIcons.pen,
                onPressed: () {
                  context.read<TranslatorCardCubit>().changeToText();
                },
              ),
              const SizedBox(width: 30),
              FloatingButton(
                color: microphoneButtonColor,
                icon: FontAwesomeIcons.microphoneLines,
                onPressed: () {
                  context.read<TranslatorCardCubit>().changeToMicrophone();
                },
              ),
              const SizedBox(width: 30),
              FloatingButton(
                color: cameraButtonColor,
                icon: FontAwesomeIcons.camera,
                onPressed: () {
                  context.read<TranslatorCardCubit>().changeToCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
