import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/views/words_list_view.dart';
import 'package:localization/localization.dart';
import 'package:translate_and_learn_app/widgets/search_text_field.dart';

class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  String _searchQuery = "";
  bool _isSearchBarVisible = false;
  final TextEditingController _searchController = TextEditingController();

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
            : Text(
                'study_words_title'.i18n(),
                style: TextStyle(fontFamily: 'CookieCrisp'),
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
            SizedBox(height: 16.0), // Add spacing when search bar is hidden
          Expanded(
            child: BlocBuilder<StudyWordsCubit, StudyWordsState>(
              builder: (context, state) {
                final filteredWords = state.studyWords.entries.where((entry) {
                  return entry.key.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredWords.isEmpty) {
                  return Center(
                    child: Text(
                      'no_words_yet'.i18n(),
                      style: TextStyle(fontFamily: 'CookieCrisp'),
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
                            entry.key,
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
                                language: entry.key,
                                words: entry.value.toList(),
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
