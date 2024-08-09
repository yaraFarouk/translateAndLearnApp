import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';

class TranslatorCardicons extends StatelessWidget {
  const TranslatorCardicons(
      {super.key,
      required this.icon1,
      this.icon2,
      required this.icon3,
      this.onPressed1,
      this.onPressed2,
      this.onPressed3});
  final IconData icon1;
  final IconData? icon2;
  final IconData icon3;
  final void Function()? onPressed1, onPressed2, onPressed3;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(icon1, color: kAppBarColor),
          onPressed: onPressed1,
        ),
        if (icon2 != null)
          IconButton(
            icon: Icon(icon2, color: kAppBarColor),
            onPressed: onPressed2,
          ),
        IconButton(
          icon: Icon(icon3, color: kAppBarColor),
          onPressed: onPressed3,
        ),
      ],
    );
  }
}
