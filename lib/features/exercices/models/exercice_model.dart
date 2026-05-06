import 'question_model.dart';

class ExerciceSectionModel {
  final String id;
  final String title;
  final List<QuestionModel> questions;

  const ExerciceSectionModel({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory ExerciceSectionModel.fromJson(Map<String, dynamic> json) {
    final questions = (json['questions'] as List? ?? [])
        .map((q) => QuestionModel.fromJson(q))
        .toList();
    return ExerciceSectionModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      questions: questions,
    );
  }
}

class ExerciceModel {
  final String id;
  final String title;
  final String subject;
  final String level;
  final String difficulty; // 'facile', 'moyen', 'difficile'
  final int questionCount;
  final List<ExerciceSectionModel> sections;
  final String? description;

  const ExerciceModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.level,
    required this.difficulty,
    required this.questionCount,
    required this.sections,
    this.description,
  });

  List<QuestionModel> get allQuestions =>
      sections.expand((s) => s.questions).toList();

  factory ExerciceModel.fromJson(Map<String, dynamic> json) {
    final sections = (json['sections'] as List? ?? [])
        .map((s) => ExerciceSectionModel.fromJson(s))
        .toList();
    return ExerciceModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      level: json['level'] ?? '',
      difficulty: json['difficulty'] ?? 'moyen',
      questionCount: json['question_count'] ?? 0,
      sections: sections,
      description: json['description'],
    );
  }
}
