class ProgressData {
  final DateTime date;
  final int wordsLearned;

  ProgressData({
    required this.date,
    required this.wordsLearned,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'wordsLearned': wordsLearned,
    };
  }

  factory ProgressData.fromMap(Map<String, dynamic> map) {
    return ProgressData(
      date: DateTime.parse(map['date']),
      wordsLearned: map['wordsLearned'],
    );
  }
}
