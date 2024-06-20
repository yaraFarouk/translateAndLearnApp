import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/words_translate_cubit.dart';
import 'package:translate_and_learn_app/views/quiz_page.dart';
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
  String _searchQuery = "";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = GenerativeModel(
        apiKey: kAPIKEY,
        model: 'gemini-1.5-flash'); // Initialize with your API key

    final filteredWords = reversedWords.where((word) {
      return word.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return BlocProvider(
      create: (context) => WordsTranslateCubit(model),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 100.h,
                    ),
                    if (!_isSearching)
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                      ),
                    if (_isSearching)
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    if (_isSearching)
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                            _searchQuery = "";
                            _searchController.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: filteredWords.length,
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
                                    .translateText(filteredWords[index],
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
                                      filteredWords[index],
                                      widget.language,
                                      "@@locale".i18n())
                                  : _buildFrontCard(
                                      context, index, cardColor, filteredWords),
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
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(
                      words: widget.words,
                      language: widget.language,
                    ),
                  ),
                );
              },
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
      ),
    );
  }

  Widget _buildFrontCard(BuildContext context, int index, Color cardColor,
      List<String> filteredWords) {
    return Card(
      key: ValueKey(false),
      color: cardColor,
      child: Center(
        child: Text(
          filteredWords[index],
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
    // If the source and target languages are the same, use the original word
    if (languageFrom == languageTo) {
      return Card(
        key: ValueKey(true),
        color: cardColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      word,
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
                  child: const Text('Study'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
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
                padding: const EdgeInsets.all(8.0),
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
