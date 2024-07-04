import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/widgets/quiz_button.dart';
import 'package:translate_and_learn_app/widgets/return_button.dart';
import 'package:translate_and_learn_app/widgets/search_text_field.dart';
import 'package:translate_and_learn_app/widgets/study_word_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordListScreen extends StatefulWidget {
  final String language;

  const WordListScreen({
    super.key,
    required this.language,
  });

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen>
    with SingleTickerProviderStateMixin {
  late List<bool> _isFlipped;
  late AnimationController _controller;
  List<QueryDocumentSnapshot> reversedDocs = [];
  List<WordDetailsModel> reversedWords = [];
  int? _currentlyFlippedIndex;
  String _searchQuery = "";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isFlipped = [];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Languages')
            .doc(widget.language)
            .collection('words')
            .get();

        List<WordDetailsModel> fetchedWords = querySnapshot.docs.map((doc) {
          return WordDetailsModel.fromDocumentSnapshot(doc);
        }).toList();

        setState(() {
          reversedDocs = querySnapshot.docs.reversed.toList();
          reversedWords = fetchedWords.reversed.toList();
          _isFlipped = List<bool>.filled(reversedWords.length, false);
          _isLoading = false;
        });
      } catch (e) {
        // Handle errors
        print(e);
      }
    }
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
    final filteredWords = reversedWords.where((word) {
      return word.word.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                            language: widget.language,
                            wordID: reversedDocs[index].id,
                            isFlipped: _isFlipped[index],
                            index: index,
                            cardColor: cardColor,
                            filteredWord: filteredWords[index],
                            reversedWord: reversedWords[index],
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
          QuizButton(words: reversedWords, language: widget.language),
    );
  }
}
