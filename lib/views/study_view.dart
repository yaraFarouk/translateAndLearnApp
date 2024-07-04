import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/words_list_view.dart';
import 'package:translate_and_learn_app/widgets/search_text_field.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  String _searchQuery = "";
  bool _isSearchBarVisible = false;
  final TextEditingController _searchController = TextEditingController();
  late Future<String> _titleFuture;
  late Future<String> _noWordsFuture;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _wordsStream;

  void _toggleSearchBar() {
    setState(() {
      _isSearchBarVisible = !_isSearchBarVisible;
      if (!_isSearchBarVisible) {
        _searchQuery = "";
        _searchController.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    LocalizationService localizationService = LocalizationService();
    _titleFuture = localizationService.fetchFromFirestore(
        'study_words_title', 'Study Words');
    _noWordsFuture =
        localizationService.fetchFromFirestore('no_words_yet', 'No words yet');
    _wordsStream = _getWordsStream();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getWordsStream() {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Languages')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: _isSearchBarVisible
            ? SearchTextField(
                searchController: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : FutureBuilder<String>(
                future: _titleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading title');
                  } else {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(fontFamily: 'CookieCrisp'),
                    );
                  }
                },
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearchBarVisible ? Icons.close : Icons.search),
            onPressed: _toggleSearchBar,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSearchBarVisible)
            const SizedBox(
                height: 16.0), // Add spacing when search bar is hidden
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _wordsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading words');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return FutureBuilder<String>(
                    future: _noWordsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading message');
                      } else {
                        return Center(
                          child: Text(
                            snapshot.data!,
                            style: const TextStyle(fontFamily: 'CookieCrisp'),
                          ),
                        );
                      }
                    },
                  );
                }

                final filteredWords = snapshot.data!.docs.where((doc) {
                  return (doc['language'] as String)
                      .toLowerCase()
                      .contains(_searchQuery);
                }).toList();

                if (filteredWords.isEmpty) {
                  return Center(
                    child: Text(
                      'No words found',
                      style: const TextStyle(fontFamily: 'CookieCrisp'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final entry = filteredWords[index];
                    final cardColor = index % 2 == 0
                        ? kTranslationCardColor
                        : kTranslatorcardColor;
                    return Card(
                      color: cardColor,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            entry['language'],
                            style: const TextStyle(
                              fontFamily: 'CookieCrisp',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kAppBarColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordListScreen(
                                language: entry['language'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
