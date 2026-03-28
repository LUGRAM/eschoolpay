class ClasseModel {
  final String id;
  final String name;
  final String schoolId;
  final String levelId;

  const ClasseModel({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.levelId,
  });

  factory ClasseModel.fromJson(Map<String, dynamic> json) {
    return ClasseModel(
      id: (json['id']).toString(),
      name: json['nom'] ?? '',
      schoolId: (json['ecole_id'] ?? '').toString(),  // ← "1" au lieu de 1
      levelId: (json['niveau_id'] ?? '').toString(),  // ← idem
    );
  }
}