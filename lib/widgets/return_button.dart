import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';

class ReturnButton extends StatefulWidget {
  const ReturnButton({super.key});

  @override
  State<ReturnButton> createState() => _ReturnButtonState();
}

class _ReturnButtonState extends State<ReturnButton> {
  final LocalizationService _localizationService = LocalizationService();
  late Future<String> _studyTranslation;

  @override
  void initState() {
    super.initState();
    _studyTranslation =
        _localizationService.fetchFromFirestore('RETURN', 'RETURN');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _studyTranslation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Handle error
        } else {
          final studyTranslation = snapshot.data ?? 'RETURN';

          return Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text(
                  studyTranslation,
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
      },
    );
  }
}
