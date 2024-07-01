import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/gemini_chat_cubit.dart';
import 'package:translate_and_learn_app/views/chat_screen.dart';

class StartChatScreen extends StatefulWidget {
  const StartChatScreen({super.key});

  @override
  _StartChatScreenState createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  String? selectedLanguage;
  bool isLoading = false;

  final Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Chinese': 'zh',
    'Japanese': 'ja',
    'Polish': 'pl',
    'Turkish': 'tr',
    'Russian': 'ru',
    'Dutch': 'nl',
    'Korean': 'ko',
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<GeminiChatCubit, GeminiChatState>(
      listener: (context, state) {
        if (state is GeminiChatInitial) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          );
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Which language do you want to learn with Gemini?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kGeminiColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: kGeminiColor,
                    width: 2,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: kGeminiColor,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    iconSize: 30,
                    elevation: 16,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    isExpanded: true,
                    value: selectedLanguage,
                    hint: const Text(
                      'Select Language',
                      style: TextStyle(color: Colors.white),
                    ),
                    items: languageCodes.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLanguage = newValue;
                      });
                      if (newValue != null) {
                        context
                            .read<GeminiChatCubit>()
                            .updateLanguageTo(languageCodes[newValue]!);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: () {
                        if (selectedLanguage != null) {
                          setState(() {
                            isLoading = true;
                          });
                          context.read<GeminiChatCubit>().resetTranslation();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a language first.'),
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: kGeminiColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Start Chat with Gemini',
                        style: TextStyle(color: kGeminiColor),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
