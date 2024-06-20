import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomAppBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Set the desired height
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), // Rounded edges
          topRight: Radius.circular(24), // Rounded edges
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24), // Rounded edges
          topRight: Radius.circular(24), // Rounded edges
        ),
        child: BottomAppBar(
          color: kAppBarColor, // Set the BottomAppBar color
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.translate,
                    color: currentIndex == 0 ? kPurpil : kPrimaryColor),
                onPressed: () => onItemTapped(0),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.book,
                    color: currentIndex == 1 ? kPurpil : kPrimaryColor),
                onPressed: () => onItemTapped(1),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.chartSimple,
                    color: Colors.white),
                onPressed: () {
                  // Handle translate button press
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/images/google-gemini-icon.png', // Path to your image
                  height: 28, // Adjust the height to your needs
                  width: 28, // Adjust the width to your needs
                ),
                onPressed: () {
                  // Handle translate button press
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.star, color: Colors.white),
                onPressed: () {
                  // Handle settings button press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
