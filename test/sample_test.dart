import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/main.dart';
// import 'package:your_app/main.dart'; // Replace with your app's main entry file

final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: kAPIKEY);
final imageModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: kAPIKEY);
final geminiChatModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: kAPIKEY);
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();


void main() {
  testWidgets('App should build without throwing', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(TranslateAndLearnApp(
      model: model,
      imageModel: imageModel,
      hasSeenWelcome: false,
      initialLocale: null,
      geminiChatModel: geminiChatModel,
      routeObserver: routeObserver,
    )); // Replace MyApp with the name of your main widget

    // Verify that the app builds without errors
    expect(find.byType(TranslateAndLearnApp), findsOneWidget);
  });
}
