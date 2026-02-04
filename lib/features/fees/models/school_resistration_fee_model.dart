class SchoolRegistrationFeeModel {
  final String schoolId;
  final String level; // ex: "6e", "Terminale", "CM2"
  final int amount;

  const SchoolRegistrationFeeModel({
    required this.schoolId,
    required this.level,
    required this.amount,
  });
}
