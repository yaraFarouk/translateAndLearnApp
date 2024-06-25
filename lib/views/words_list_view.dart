import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/words_translate_cubit.dart';
import 'package:localization/localization.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/widgets/quiz_button.dart';
import 'package:translate_and_learn_app/widgets/return_button.dart';
import 'package:translate_and_learn_app/widgets/search_text_field.dart';
import 'package:translate_and_learn_app/widgets/study_word_card.dart';

class WordListScreen extends StatefulWidget {
  final String language;
  final List<WordDetailsModel> words;

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
  late List<WordDetailsModel> reversedWords;
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
      return word.word.toLowerCase().contains(_searchQuery.toLowerCase());
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
                        SearchTextField(
                          searchController: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      if (_isSearching)
                        IconButton(
                          icon: const Icon(Icons.close),
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

                        return StudyWordCard(
                          isFlipped: _isFlipped[index],
                          index: index,
                          cardColor: cardColor,
                          filteredWord: filteredWords[index],
                          reversedWord: reversedWords[index],
                          languageFrom: widget.language,
                          languageTo: "@@locale".i18n(),
                          onTap: () {
                            _flipCard(index);
                          },
                        );
                      },
                    ),
                    const ReturnButton(),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton:
              QuizButton(words: widget.words, language: widget.language)),
    );
  }
}
