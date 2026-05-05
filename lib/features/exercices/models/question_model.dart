class QuestionModel {
  final String id;
  final String statement;
  final String type; // 'qcm' or 'texte_libre'
  final List<String>? options;
  final String correctAnswer;
  final String? explanation;

  const QuestionModel({
    required this.id,
    required this.statement,
    required this.type,
    this.options,
    required this.correctAnswer,
    this.explanation,
  });

  bool get isQcm => type == 'qcm';

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'].toString(),
      statement: json['statement'] ?? '',
      type: json['type'] ?? 'texte_libre',
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctAnswer: json['correct_answer'] ?? '',
      explanation: json['explanation'],
    );
  }
}
