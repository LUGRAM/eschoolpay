class RegistrationFeeModel {
  final String schoolId;
  final String schoolName;
  final String level;
  final int amount;

  const RegistrationFeeModel({
    required this.schoolId,
    required this.schoolName,
    required this.level,
    required this.amount,
  });
}

const mockRegistrationFees = [
  RegistrationFeeModel(
    schoolId: 'sch_1',
    schoolName: 'Lycée Léon Mba',
    level: 'Terminale',
    amount: 65000,
  ),
  RegistrationFeeModel(
    schoolId: 'sch_1',
    schoolName: 'Lycée Léon Mba',
    level: 'Seconde',
    amount: 50000,
  ),
  RegistrationFeeModel(
    schoolId: 'sch_2',
    schoolName: 'CES Akébé',
    level: '6e',
    amount: 30000,
  ),
  RegistrationFeeModel(
    schoolId: 'sch_2',
    schoolName: 'CES Akébé',
    level: '3e',
    amount: 40000,
  ),
];
