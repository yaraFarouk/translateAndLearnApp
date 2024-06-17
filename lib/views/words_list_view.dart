import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/words_translate_cubit.dart';
import 'package:translate_and_learn_app/views/word_details_screen.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart'; // Ensure this is the correct path
import 'package:localization/localization.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class WordListScreen extends StatefulWidget {
  final String language;
  final List<String> words;

  const WordListScreen({
    super.key,
    required this.language,
    required this.words,
  });

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen>
    with SingleTickerProviderStateMixin {
  late List<bool> _isFlipped;
  late AnimationController _controller;
  late List<String> reversedWords;
  int? _currentlyFlippedIndex;

  @override
  void initState() {
    super.initState();
    reversedWords = widget.words.reversed.toList(); // Reverse the list here
    _isFlipped = List<bool>.filled(reversedWords.length, false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _flipCard(int index) {
    setState(() {
      if (_currentlyFlippedIndex != null && _currentlyFlippedIndex != index) {
        _isFlipped[_currentlyFlippedIndex!] = false;
      }
      _isFlipped[index] = !_isFlipped[index];
      _currentlyFlippedIndex = _isFlipped[index] ? index : null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = GenerativeModel(
        apiKey: kAPIKEY,
        model: 'gemini-1.5-flash'); // Initialize with your API key
    return BlocProvider(
      create: (context) => WordsTranslateCubit(model),
      child: Scaffold(
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
                    itemCount: reversedWords.length,
                    itemBuilder: (context, index) {
                      Color cardColor = index % 2 == 0
                          ? kTranslationCardColor
                          : kTranslatorcardColor;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: SizedBox(
                          height: 150,
                          child: GestureDetector(
                            onTap: () {
                              _flipCard(index);
                              if (_isFlipped[index]) {
                                BlocProvider.of<WordsTranslateCubit>(context)
                                    .translateText(reversedWords[index],
                                        widget.language, "@@locale".i18n());
                              }
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FlipTransition(
                                  animation: animation,
                                  child: child,
                                );
                              },
                              child: _isFlipped[index]
                                  ? _buildBackCard(
                                      context,
                                      index,
                                      cardColor,
                                      reversedWords[index],
                                      widget.language,
                                      "@@locale".i18n())
                                  : _buildFrontCard(context, index, cardColor),
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
                          side:
                              const BorderSide(color: kAppBarColor, width: 2.0),
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
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context, int index, Color cardColor) {
    return Card(
      key: ValueKey(false),
      color: cardColor,
      child: Center(
        child: Text(
          reversedWords[index],
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 33,
              fontFamily: 'CookieCrisp',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBackCard(BuildContext context, int index, Color cardColor,
      String word, String languageFrom, String languageTo) {
    return BlocBuilder<WordsTranslateCubit, WordsTranslateState>(
      builder: (context, state) {
        String translation = 'Loading...';

        if (_isFlipped[index]) {
          if (state is WordsTranslateSuccess) {
            translation = state.response;
          } else if (state is WordsTranslateError) {
            translation = state.error;
          }
        }

        return Card(
          key: ValueKey(true),
          color: cardColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add some padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        translation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 33,
                          fontFamily: 'CookieCrisp',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordDetailsScreen(
                            word: reversedWords[index],
                            language: widget.language,
                          ),
                        ),
                      );
                    },
                    child: const Text('Details'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FlipTransition extends AnimatedWidget {
  const FlipTransition({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(animation.value * 3.1415927);

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: animation.value < 0.5
          ? child
          : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1415927),
              child: child,
            ),
    );
  }
}
