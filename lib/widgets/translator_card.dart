import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/favorites_cubit.dart';
import 'package:translate_and_learn_app/widgets/custom_drop_down_button.dart';
import 'package:translate_and_learn_app/widgets/custom_text_field.dart';
import 'package:translate_and_learn_app/widgets/translator_card_icons.dart';

class TranslatorCard extends StatefulWidget {
  final Color color;
  final String hint;

  const TranslatorCard({
    super.key,
    required this.color,
    required this.hint,
  });

  @override
  State<TranslatorCard> createState() => _TranslatorCardState();
}

class _TranslatorCardState extends State<TranslatorCard> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(
      languageCodes[context.read<FavoritesCubit>().getLanguageFrom()] ??
          'en_EN',
    );
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kTranslatorcardColor, // Set background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: kGeminiColor, // Set the border color
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomDropDownButton(
              translation: 1,
            ),
            Row(children: [
              Expanded(
                child: CustomTextField(
                  hint: widget.hint,
                  controller: _controller,
                ),
              ),
              const SizedBox(width: 10),
              TranslatorCardicons(
                icon1: FontAwesomeIcons.trash,
                onPressed1: () {
                  setState(() {
                    _controller.clear();
                  });
                },
                icon3: FontAwesomeIcons.volumeHigh,
                onPressed3: () {
                  _speak(_controller.text);
                },
              ),
            ])
          ],
        ),
      ),
    );
  }
}
