class LessonModel {
  final String id;
  final String title;
  final String type; // 'video' or 'text'
  final String? videoUrl;
  final String? content;
  final String duration;
  final int order;

  const LessonModel({
    required this.id,
    required this.title,
    required this.type,
    this.videoUrl,
    this.content,
    required this.duration,
    required this.order,
  });

  bool get isVideo => type == 'video';
  bool get isText => type == 'text';

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      type: json['type'] ?? 'video',
      videoUrl: json['video_url'],
      content: json['content'],
      duration: json['duration'] ?? '0min',
      order: json['order'] ?? 0,
    );
  }
}
