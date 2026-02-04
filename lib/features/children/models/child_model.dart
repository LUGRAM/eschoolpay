class ChildModel {
  final String id;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String birthPlace;

  // Infos inscription
  String? schoolId;
  String? schoolName;
  String? grade;
  String? academicYear;

  ChildModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.birthPlace,
    this.schoolId,
    this.schoolName,
    this.grade,
    this.academicYear,
  });

  String get fullName => "$firstName $lastName";

  bool get isAlreadyRegisteredThisYear =>
      academicYear == currentAcademicYear;

  static String get currentAcademicYear {
    final now = DateTime.now();
    final startYear = now.month >= 9 ? now.year : now.year - 1;
    return "$startYear-${startYear + 1}";
  }

  // Ces getters garantissent un String non-nul pour tes widgets
  String get displaySchool => schoolName ?? "Non renseignée";
  String get displayGrade => grade ?? "Classe non renseignée";
}
