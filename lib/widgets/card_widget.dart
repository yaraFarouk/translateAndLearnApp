import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomDropDownButton(
                    translation: false,
                  ),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.copy,
                      color: kAppBarColor,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Text copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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
                TranslatorCardicons(
                  icon1: FontAwesomeIcons.star,
                  icon2: FontAwesomeIcons.volumeHigh,
                  icon3: FontAwesomeIcons.plus,
                  onPressed3: () {
                    // Add new words to the study words list
                    BlocProvider.of<StudyWordsCubit>(context).addNewWords(
                      BlocProvider.of<StudyWordsCubit>(context)
                          .state
                          .languageTo,
                      widget.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Words added to study list')),
                    );
                  },
                ),
              ]),
            ])));
  }
}
