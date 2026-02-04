import '../models/school_resistration_fee_model.dart';

const mockRegistrationFees = [
  // Lycée Léon Mba
  SchoolRegistrationFeeModel(
    schoolId: 'sch_1',
    level: 'Seconde',
    amount: 50000,
  ),
  SchoolRegistrationFeeModel(
    schoolId: 'sch_1',
    level: 'Terminale',
    amount: 65000,
  ),

  // CES Akébé
  SchoolRegistrationFeeModel(
    schoolId: 'sch_2',
    level: '6e',
    amount: 30000,
  ),
  SchoolRegistrationFeeModel(
    schoolId: 'sch_2',
    level: '3e',
    amount: 40000,
  ),
];
