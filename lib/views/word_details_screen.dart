import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/cubit/cubit/dictionary_cubit.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart';
import 'package:translate_and_learn_app/widgets/text_container.dart'; // import the DictionaryCubit

class WordDetailsScreen extends StatelessWidget {
  const WordDetailsScreen(
      {super.key, required this.word, required this.language});
  final String word;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 70),
            CustomAppTopBar(
              title: word,
              icon: Icons.search,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: WordDetailsView(
                language: language,
                word: word,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordDetailsView extends StatelessWidget {
  const WordDetailsView(
      {super.key, required this.word, required this.language});
  final String word;
  final String language;

  @override
  Widget build(BuildContext context) {
    context.read<DictionaryCubit>().getWordDetails(word, language);

    return BlocBuilder<DictionaryCubit, DictionaryState>(
      builder: (context, state) {
        if (state is DictionaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DictionarySuccess) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextContainer(
                    title: "Meaning",
                    content: Text.rich(
                      parseFormattedText(state.meaning),
                      style: const TextStyle(fontSize: 18.0),
                    )),
                const SizedBox(height: 16.0),
                TextContainer(
                    title: "Definition",
                    content: Text.rich(
                      parseFormattedText(state.definition),
                      style: const TextStyle(fontSize: 18.0),
                    )),
                const SizedBox(height: 16.0),
                TextContainer(
                    title: "Examples",
                    content: Text.rich(
                      parseFormattedText(state.examples),
                      style: const TextStyle(fontSize: 18.0),
                    )),
              ],
            ),
          );
        } else if (state is DictionaryError) {
          return Center(child: Text(state.error));
        } else {
          return Container(); // Empty container for initial state
        }
      },
    );
  }
}

TextSpan parseFormattedText(String text) {
  List<TextSpan> spans = [];
  final parts = text.split(RegExp(r'(\*|#)'));

  bool isBold = false;
  bool isItalic = false;

  for (final part in parts) {
    if (part == '*') {
      isBold = !isBold;
    } else if (part == '#') {
      isItalic = !isItalic;
    } else {
      spans.add(
        TextSpan(
          text: part,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      );
    }
  }

  return TextSpan(children: spans);
}
