import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/views/home_view.dart';
import 'package:translate_and_learn_app/views/welcome_screen4.dart';

class WelcomeScreen3 extends StatelessWidget {
  const WelcomeScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // First floating button
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen4()),
                  );
                },
                label: const Text(
                  'Skip',
                  style: TextStyle(fontFamily: 'CookieCrisp'),
                ),

                heroTag: 'Skip', // Unique hero tag for the RETURN button
                backgroundColor:
                    kTranslatorcardColor, // Match the background color
                foregroundColor: Colors.black, // Text and icon color
                elevation: 4, // Match the elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0), // Match the shape
                  side: BorderSide(
                      color: kTranslatorcardColor,
                      width: 2.0), // Match the border
                ),
              ),
            ),
          ),
          // Second floating button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen4()),
                  );
                },
                label: const Text(
                  'Next',
                  style: TextStyle(fontFamily: 'CookieCrisp'),
                ),
                heroTag: 'Next', // Unique hero tag for the RETURN button
                backgroundColor:
                    kTranslationCardColor, // Match the background color
                foregroundColor: Colors.black, // Text and icon color
                elevation: 4, // Match the elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0), // Match the shape
                  side: BorderSide(
                      color: kTranslationCardColor,
                      width: 2.0), // Match the border
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
