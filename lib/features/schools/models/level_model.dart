class LevelModel {
  final int id;
  final String name;

  const LevelModel({
    required this.id,
    required this.name,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as int,
      name: (json['nom'] ?? '').toString()
    );
  }
}