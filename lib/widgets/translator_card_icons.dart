import 'package:flutter/material.dart';

class TranslatorCardicons extends StatelessWidget {
  const TranslatorCardicons(
      {super.key,
      required this.icon1,
      required this.icon2,
      required this.icon3});
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(icon1, color: Colors.black),
          onPressed: () {
            // Handle delete action
          },
        ),
        IconButton(
          icon: Icon(icon2, color: Colors.black),
          onPressed: () {
            // Handle star action
          },
        ),
        IconButton(
          icon: Icon(icon3, color: Colors.black),
          onPressed: () {
            // Handle volume action
          },
        ),
      ],
    );
  }
}
