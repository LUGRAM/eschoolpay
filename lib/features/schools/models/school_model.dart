
class SchoolModel {
  final String id;
  final String name;
  final String city;

  const SchoolModel({
    required this.id,
    required this.name,
    required this.city,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: (json['id']).toString(),
      name: (json['nom'] ?? '').toString(),
      city: (json['ville'] ?? '').toString(),
    );
  }
}