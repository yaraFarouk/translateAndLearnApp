import 'package:flutter/material.dart';

class TranslatorCardicons extends StatelessWidget {
  const TranslatorCardicons(
      {super.key,
      required this.icon1,
      required this.icon2,
      required this.icon3,
      this.onPressed1,
      this.onPressed2,
      this.onPressed3});
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final void Function()? onPressed1, onPressed2, onPressed3;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(icon1, color: Colors.black),
          onPressed: onPressed1,
        ),
        IconButton(
          icon: Icon(icon2, color: Colors.black),
          onPressed: onPressed2,
        ),
        IconButton(
          icon: Icon(icon3, color: Colors.black),
          onPressed: onPressed3,
        ),
      ],
    );
  }
}
