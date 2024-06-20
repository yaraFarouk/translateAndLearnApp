import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text(
            'RETURN',
            style: TextStyle(fontFamily: 'CookieCrisp'),
          ),
          icon: const Icon(Icons.arrow_back),
          heroTag: 'returnBtn',
          backgroundColor: kAppBarColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: const BorderSide(color: kAppBarColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}
