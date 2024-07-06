import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          textButtonColor = kPurpil;
        } else if (state is TranslatorCardMicrophoneSelected) {
          microphoneButtonColor = kPurpil;
        } else if (state is TranslatorCardCameraSelected) {
          cameraButtonColor = kPurpil;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 18.h),
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
              SizedBox(width: 30.w),
              FloatingButton(
                color: microphoneButtonColor,
                icon: FontAwesomeIcons.microphoneLines,
                onPressed: () {
                  context.read<TranslatorCardCubit>().changeToMicrophone();
                },
              ),
              SizedBox(width: 30.w),
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
