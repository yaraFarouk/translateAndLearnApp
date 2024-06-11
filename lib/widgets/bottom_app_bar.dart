import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:translate_and_learn_app/constants.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

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
                icon: const Icon(Icons.translate, color: Colors.white),
                onPressed: () {
                  // Handle home button press
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.book, color: Colors.white),
                onPressed: () {
                  // Handle search button press
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.chartSimple,
                    color: Colors.white),
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
