import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:translate_and_learn_app/main.dart'; // Replace with the path to your main.dart or equivalent file
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test if main app builds without errors', (WidgetTester tester) async {
    // Initialize Firebase (if needed)
    await Firebase.initializeApp();

    // Mock SharedPreferences for the test
    SharedPreferences.setMockInitialValues({});

    // Mock required parameters for TranslateAndLearnApp widget
    final model = GenerativeModel(model: 'mock-model', apiKey: 'mock-api-key');
    final imageModel = GenerativeModel(model: 'mock-model', apiKey: 'mock-api-key');
    final geminiChatModel = GenerativeModel(model: 'mock-model', apiKey: 'mock-api-key');
    final hasSeenWelcome = true; // Replace with a mock value as needed
    final initialLocale = Locale('en'); // Replace with a mock Locale if needed

    // Build your app and trigger a frame.
    await tester.pumpWidget(TranslateAndLearnApp(
      model: model,
      imageModel: imageModel,
      hasSeenWelcome: hasSeenWelcome,
      initialLocale: initialLocale,
      geminiChatModel: geminiChatModel,
    ));

    // Verify if the app launched without errors
    expect(find.byType(MaterialApp), findsOneWidget); // Replace MaterialApp with your app's main widget type
  });
}
