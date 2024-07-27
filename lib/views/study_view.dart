import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/services/localization_service.dart';
import 'package:translate_and_learn_app/views/words_list_view.dart';
import 'package:translate_and_learn_app/widgets/search_text_field.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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

  Stream<int> _learnedWordsCountStream(String language) {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('all_words')
        .doc(user!.uid)
        .collection(language)
        .where('isCorrect', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<int> _totalWordsCountStream(String language) {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Languages')
        .doc(language)
        .collection('words')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                      style: TextStyle(fontFamily: kFont, fontSize: 20.sp),
                    );
                  }
                },
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearchBarVisible ? Icons.close : Icons.search,
                size: 24.sp),
            onPressed: _toggleSearchBar,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSearchBarVisible)
            SizedBox(height: 16.h), // Add spacing when search bar is hidden
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
                            style:
                                TextStyle(fontFamily: kFont, fontSize: 16.sp),
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
                      style: TextStyle(fontFamily: kFont, fontSize: 16.sp),
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

                    return StreamBuilder<int>(
                      stream: _learnedWordsCountStream(entry['language']),
                      builder: (context, learnedWordsSnapshot) {
                        if (learnedWordsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (learnedWordsSnapshot.hasError) {
                          return const Text('Error loading progress');
                        } else {
                          final learnedWordsCount = learnedWordsSnapshot.data!;
                          return StreamBuilder<int>(
                            stream: _totalWordsCountStream(entry['language']),
                            builder: (context, totalWordsSnapshot) {
                              if (totalWordsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (totalWordsSnapshot.hasError) {
                                return const Text('Error loading total words');
                              } else {
                                final totalWords = totalWordsSnapshot.data!;
                                final progress = learnedWordsCount / totalWords;

                                return Card(
                                  color: cardColor,
                                  margin: EdgeInsets.all(10.r),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    title: Center(
                                      child: Text(
                                        entry['language'],
                                        style: TextStyle(
                                          fontFamily: kFont,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kAppBarColor,
                                        ),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: LinearPercentIndicator(
                                        lineHeight: 14.0,
                                        percent: progress > 1 ? 1 : progress,
                                        center: Text(
                                          '$learnedWordsCount/$totalWords',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: kAppBarColor,
                                          ),
                                        ),
                                        barRadius: Radius.circular(7.0),
                                        backgroundColor:
                                            Color.fromARGB(255, 253, 242, 255),
                                        progressColor: kPurpil,
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
                              }
                            },
                          );
                        }
                      },
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
