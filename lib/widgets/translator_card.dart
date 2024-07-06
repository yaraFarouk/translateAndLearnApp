import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                icon3: FontAwesomeIcons.volumeHigh,
                onPressed1: () {
                  setState(() {
                    _controller.clear();
                  });
                },
              ),
            ])
          ],
        ),
      ),
    );
  }
}
