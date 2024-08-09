import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/widgets/custom_drop_down_button.dart';
import 'package:translate_and_learn_app/widgets/floating_button.dart';

class MicrophonTranslatorCard extends StatefulWidget {
  final Color color;

  const MicrophonTranslatorCard({
    super.key,
    required this.color,
    required this.hint,
  });

  final String hint;

  @override
  State<MicrophonTranslatorCard> createState() =>
      _MicrophonTranslatorCardState();
}

class _MicrophonTranslatorCardState extends State<MicrophonTranslatorCard> {
  String selectedValue = 'English';
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: kGeminiColor, // Set the border color
            width: 1.5,
          ),
        ),
        color: widget.color,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomDropDownButton(translation: 1),
                  const CustomDropDownButton(translation: 1),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  FloatingRecordingButton(
                    isRecording: isRecording,
                    onPressed: () {
                      setState(() {
                        isRecording = !isRecording;
                      });
                    },
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trash,
                      color: kAppBarColor,
                    ),
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                height: 26,
              ),
              const Text(
                'text will appear here',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingRecordingButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onPressed;

  const FloatingRecordingButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
      color: kPrimaryColor,
      icon: isRecording
          ? FontAwesomeIcons.solidCircleStop
          : FontAwesomeIcons.microphoneLines,
      onPressed: onPressed,
    );
  }
}
