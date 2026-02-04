class ClassLevelModel {
  final String id;
  final String label; // ex: "6e", "3e", "Terminale A"
  final String cycle; // Collège / Lycée

  const ClassLevelModel({
    required this.id,
    required this.label,
    required this.cycle,
  });
}
