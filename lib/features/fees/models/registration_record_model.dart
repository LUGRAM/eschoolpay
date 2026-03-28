class RegistrationRecordModel {
  final String id;
  final String childId;
  final String childName;
  final String schoolName;
  final String grade;
  final int amount;
  final String academicYear;
  final DateTime date;

  RegistrationRecordModel({
    required this.id,
    required this.childId,
    required this.childName,
    required this.schoolName,
    required this.grade,
    required this.amount,
    required this.academicYear,
    required this.date,
  });
}
