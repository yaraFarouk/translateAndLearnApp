import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translate_and_learn_app/models/word_details_model.dart';
import 'package:translate_and_learn_app/widgets/custom_app_top_bar.dart';
import 'package:translate_and_learn_app/widgets/text_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordDetailsScreen extends StatefulWidget {
  const WordDetailsScreen(
      {super.key, required this.wordId, required this.language});
  final String wordId;
  final String language;

  @override
  _WordDetailsScreenState createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  late Future<WordDetailsModel> _wordDetails;

  @override
  void initState() {
    super.initState();
    _wordDetails = _fetchWordDetails();
  }

  Future<WordDetailsModel> _fetchWordDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Languages')
          .doc(widget.language)
          .collection('words')
          .doc(widget.wordId)
          .get();

      if (doc.exists) {
        return WordDetailsModel.fromDocumentSnapshot(doc);
      } else {
        throw Exception("Word not found");
      }
    } else {
      throw Exception("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WordDetailsModel>(
        future: _wordDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Word not found'));
          } else {
            final word = snapshot.data!;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 70.h),
                  CustomAppTopBar(
                    title: word.word,
                    icon: Icons.search,
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: WordDetailsView(
                      word: word,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class WordDetailsView extends StatelessWidget {
  const WordDetailsView({super.key, required this.word});
  final WordDetailsModel word;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextContainer(
              title: "Meaning",
              content: Text.rich(
                parseFormattedText(word.meaning),
                style: TextStyle(fontSize: 18.sp),
              )),
          SizedBox(height: 16.h),
          TextContainer(
              title: "Definition",
              content: Text.rich(
                parseFormattedText(word.definition),
                style: TextStyle(fontSize: 18.sp),
              )),
          SizedBox(height: 16.h),
          TextContainer(
              title: "Examples",
              content: Text.rich(
                parseFormattedText(word.examples),
                style: TextStyle(fontSize: 18.sp),
              )),
        ],
      ),
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
