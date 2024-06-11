import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/widgets/custom_drop_down_button.dart';
import 'package:translate_and_learn_app/widgets/translator_card_icons.dart';

class Languagecard extends StatefulWidget {
  final String text;
  final Color color;

  const Languagecard({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  State<Languagecard> createState() => _LanguagecardState();
}

class _LanguagecardState extends State<Languagecard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const CustomDropDownButton(
                translation: false,
              ),
              Row(children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const TranslatorCardicons(
                  icon1: FontAwesomeIcons.copy,
                  icon2: FontAwesomeIcons.star,
                  icon3: FontAwesomeIcons.volumeHigh,
                ),
              ]),
            ])));
  }
}
