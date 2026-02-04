import 'class_level_model.dart';

class SchoolModel {
  final String id;
  final String name;
  final String city;
  final List<ClassLevelModel> levels;

  const SchoolModel({
    required this.id,
    required this.name,
    required this.city,
    required this.levels,
  });
}
