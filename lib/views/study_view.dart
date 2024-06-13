import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translate_and_learn_app/constants.dart';
import 'package:translate_and_learn_app/cubit/cubit/study_words_cubit.dart';
import 'package:translate_and_learn_app/views/words_list_view.dart';

class StudyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Study Words',
          style: TextStyle(fontFamily: 'CookieCrisp'),
        ),
      ),
      body: BlocBuilder<StudyWordsCubit, StudyWordsState>(
        builder: (context, state) {
          if (state.studyWords.isEmpty) {
            return const Center(
              child: Text(
                'No words added yet.',
                style: TextStyle(fontFamily: 'CookieCrisp'),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.studyWords.length,
            itemBuilder: (context, index) {
              final entry = state.studyWords.entries.elementAt(index);
              final cardColor =
                  index % 2 == 0 ? kTranslationCardColor : kTranslatorcardColor;
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
    );
  }
}
