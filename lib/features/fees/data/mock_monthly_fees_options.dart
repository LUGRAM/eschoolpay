import '../models/monthly_fee_config_model.dart';

final mockMonthlyFees = [

  // ───────────────── Lycée Léon Mba ─────────────────
  MonthlyFeeConfig(
    schoolId: 'sch_1',
    level: 'Seconde',
    options: const [
      MonthlyFeeOption(months: 1, amount: 45000),
      MonthlyFeeOption(months: 3, amount: 135000, discountPercent: 10),
      MonthlyFeeOption(months: 6, amount: 270000, discountPercent: 20),
      MonthlyFeeOption(months: 12, amount: 540000, discountPercent: 30),
    ],
  ),

  //  TERMINALE — Lycée Léon Mba
  MonthlyFeeConfig(
    schoolId: 'sch_1',
    level: 'Terminale',
    options: const [
      MonthlyFeeOption(months: 1, amount: 60000),
      MonthlyFeeOption(months: 3, amount: 180000, discountPercent: 10),
      MonthlyFeeOption(months: 6, amount: 360000, discountPercent: 20),
      MonthlyFeeOption(months: 12, amount: 720000, discountPercent: 30),
    ],
  ),

  // ───────────────── CES Akébé ─────────────────
  MonthlyFeeConfig(
    schoolId: 'sch_2',
    level: '6e',
    options: const [
      MonthlyFeeOption(months: 1, amount: 30000),
      MonthlyFeeOption(months: 3, amount: 90000, discountFixed: 5000),
      MonthlyFeeOption(months: 6, amount: 180000, discountFixed: 15000),
    ],
  ),

  //  TERMINALE — CES Akébé
  MonthlyFeeConfig(
    schoolId: 'sch_2',
    level: 'Terminale',
    options: const [
      MonthlyFeeOption(months: 1, amount: 50000),
      MonthlyFeeOption(months: 3, amount: 150000, discountFixed: 10000),
      MonthlyFeeOption(months: 6, amount: 300000, discountFixed: 30000),
      MonthlyFeeOption(months: 12, amount: 600000, discountFixed: 60000),
    ],
  ),
];
