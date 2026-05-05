import 'lesson_model.dart';

class CourseSectionModel {
  final String id;
  final String title;
  final List<LessonModel> lessons;
  final int order;

  const CourseSectionModel({
    required this.id,
    required this.title,
    required this.lessons,
    required this.order,
  });

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) {
    final lessons = (json['lessons'] as List? ?? [])
        .map((l) => LessonModel.fromJson(l))
        .toList();
    return CourseSectionModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      lessons: lessons,
      order: json['order'] ?? 0,
    );
  }
}

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String duration;
  final int lessonCount;
  final String subject;
  final String level;
  final List<CourseSectionModel> sections;
  final bool isSingleVideo;
  final LessonModel? singleLesson;
  final double progressPercent;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    required this.duration,
    required this.lessonCount,
    required this.subject,
    required this.level,
    this.sections = const [],
    this.isSingleVideo = false,
    this.singleLesson,
    this.progressPercent = 0.0,
  });

  List<LessonModel> get allLessons {
    if (isSingleVideo && singleLesson != null) return [singleLesson!];
    return sections.expand((s) => s.lessons).toList();
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final sections = (json['sections'] as List? ?? [])
        .map((s) => CourseSectionModel.fromJson(s))
        .toList();
    LessonModel? singleLesson;
    if (json['single_lesson'] != null) {
      singleLesson = LessonModel.fromJson(json['single_lesson']);
    }
    return CourseModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      duration: json['duration'] ?? '0min',
      lessonCount: json['lesson_count'] ?? 0,
      subject: json['subject'] ?? '',
      level: json['level'] ?? '',
      sections: sections,
      isSingleVideo: json['is_single_video'] ?? false,
      singleLesson: singleLesson,
      progressPercent: (json['progress_percent'] ?? 0.0).toDouble(),
    );
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? duration,
    int? lessonCount,
    String? subject,
    String? level,
    List<CourseSectionModel>? sections,
    bool? isSingleVideo,
    LessonModel? singleLesson,
    double? progressPercent,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      lessonCount: lessonCount ?? this.lessonCount,
      subject: subject ?? this.subject,
      level: level ?? this.level,
      sections: sections ?? this.sections,
      isSingleVideo: isSingleVideo ?? this.isSingleVideo,
      singleLesson: singleLesson ?? this.singleLesson,
      progressPercent: progressPercent ?? this.progressPercent,
    );
  }
}
