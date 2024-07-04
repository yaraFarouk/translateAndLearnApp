import 'package:cloud_firestore/cloud_firestore.dart';

class WordDetailsModel {
  final String word;
  final String translation;
  final String languageofWord;
  final String languageoftranslation;
  final String meaning;
  final String definition;
  final String examples;

  WordDetailsModel({
    required this.word,
    required this.translation,
    required this.languageofWord,
    required this.languageoftranslation,
    required this.meaning,
    required this.definition,
    required this.examples,
  });

  // Convert a WordDetailsModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation,
      'languageofWord': languageofWord,
      'languageoftranslation': languageoftranslation,
      'meaning': meaning,
      'definition': definition,
      'examples': examples,
    };
  }

  // Create a WordDetailsModel from a map
  factory WordDetailsModel.fromMap(Map<String, dynamic> map) {
    return WordDetailsModel(
      word: map['word'],
      translation: map['translation'],
      languageofWord: map['languageofWord'],
      languageoftranslation: map['languageoftranslation'],
      meaning: map['meaning'],
      definition: map['definition'],
      examples: map['examples'],
    );
  }

  // Convert a WordDetailsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'languageofWord': languageofWord,
      'languageoftranslation': languageoftranslation,
      'meaning': meaning,
      'definition': definition,
      'examples': examples,
    };
  }

  // Create a WordDetailsModel from JSON
  factory WordDetailsModel.fromJson(Map<String, dynamic> json) {
    return WordDetailsModel(
      word: json['word'],
      translation: json['translation'],
      languageofWord: json['languageofWord'],
      languageoftranslation: json['languageoftranslation'],
      meaning: json['meaning'],
      definition: json['definition'],
      examples: json['examples'],
    );
  }
  factory WordDetailsModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return WordDetailsModel(
      word: doc['word'],
      translation: doc['translation'],
      languageofWord: doc['languageofWord'],
      languageoftranslation: doc['languageoftranslation'],
      meaning: doc['meaning'],
      definition: doc['definition'],
      examples: doc['examples'],
    );
  }
}
