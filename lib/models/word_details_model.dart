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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordDetailsModel &&
          runtimeType == other.runtimeType &&
          word == other.word;

  @override
  int get hashCode => word.hashCode;
}
