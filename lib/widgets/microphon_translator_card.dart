import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/cubit/gemini_api_cubit.dart';
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
  bool isRecording = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _text = '';

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      default:
        PermissionStatus.denied;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    setState(() {
      isRecording = true;
    });

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: languageCodes[context.read<FavoritesCubit>().getLanguageFrom()],
      // listenOptions: SpeechListenOptions(
      //   cancelOnError: false,
      //   partialResults: false,
      //   listenMode: ListenMode.confirmation,
      // ),
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    isRecording = false;
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _text = result.recognizedWords;
    setState(() {});
    context.read<GeminiApiCubit>().translateText(_text);
    context.read<FavoritesCubit>().updateText(_text);
    if (result.finalResult) {
      setState(() {
        isRecording = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.star),
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                  ),
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
                      _speechToText.isNotListening
                          ? _startListening.call()
                          : _stopListening.call();
                    },
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.trash,
                      color: kAppBarColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _text = '';
                      });
                      context.read<GeminiApiCubit>().translateText(_text);
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
              Text(
                _text.isNotEmpty ? _text : 'text will appear here',
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
