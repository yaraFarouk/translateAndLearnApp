class QuizModel {
  final String question, choice1, choice2, choice3, choice4, proof;

  QuizModel(
      {required this.question,
      required this.choice1,
      required this.choice2,
      required this.choice3,
      required this.choice4,
      required this.proof});
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'choice1': choice1,
      'choice2': choice2,
      'choice3': choice3,
      'choice4': choice4,
      'proof': proof,
    };
  }

  // Create a WordDetailsModel from JSON
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'],
      choice1: json['choice1'],
      choice2: json['choice2'],
      choice3: json['choice3'],
      choice4: json['choice4'],
      proof: json['proof'],
    );
  }
}
