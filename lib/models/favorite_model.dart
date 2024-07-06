class FavoriteModel {
  final String languageFrom;
  final String langugaeTo;
  final String text;
  final String translation;

  FavoriteModel({
    required this.languageFrom,
    required this.langugaeTo,
    required this.text,
    required this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'languageFrom': languageFrom,
      'languageTo': langugaeTo,
      'text': text,
      'translation': translation,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      languageFrom: map['languageFrom'],
      langugaeTo: map['languageTo'],
      text: map['text'],
      translation: map['translation'],
    );
  }
}
