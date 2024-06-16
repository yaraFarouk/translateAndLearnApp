import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart'; // Ensure this is the correct path
import 'package:localization/localization.dart';

class WordListScreen extends StatelessWidget {
  final String language;
  final List<String> words;

  const WordListScreen({
    super.key,
    required this.language,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          const SizedBox(height: 70),
          CustomAppTopBar(
            title: 'Study Words'.i18n(),
            icon: Icons.search,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    // Alternate colors based on index
                    Color cardColor = index % 2 == 0
                        ? kTranslationCardColor
                        : kTranslatorcardColor;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: SizedBox(
                        height: 150, // Set a fixed height for the square card
                        child: Card(
                          color: cardColor, // Set card color
                          child: Center(
                            child: Text(
                              words[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 33,
                                  fontFamily: 'CookieCrisp',
                                  fontWeight:
                                      FontWeight.bold), // Increase text size
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.pop(context); // Return to the previous screen
                      },
                      label: const Text(
                        'RETURN',
                        style: TextStyle(fontFamily: 'CookieCrisp'),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      heroTag:
                          'returnBtn', // Unique hero tag for the RETURN button
                      backgroundColor:
                          kAppBarColor, // Match the background color
                      foregroundColor: Colors.white, // Text and icon color
                      elevation: 4, // Match the elevation
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40.0), // Match the shape
                        side: const BorderSide(
                            color: kAppBarColor,
                            width: 2.0), // Match the border
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kAppBarColor, width: 2.0),
            borderRadius: BorderRadius.circular(40.0),
            color: kAppBarColor,
          ),
          child: const Material(
            color: kPrimaryColor,
            elevation: 4,
            shadowColor: kAppBarColor,
            shape: CircleBorder(),
            child: Center(
              // Ensure the text is centered
              child: Text(
                'QUIZ',
                style: TextStyle(
                    fontFamily: 'CookieCrisp',
                    color: kAppBarColor,
                    fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
