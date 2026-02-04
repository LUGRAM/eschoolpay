// lib/features/fees/models/monthly_fee_config_model.dart

class MonthlyFeeOption {
  final int months;
  final int amount;
  final int? discountPercent;
  final int? discountFixed;

  const MonthlyFeeOption({
    required this.months,
    required this.amount,
    this.discountPercent,
    this.discountFixed,
  });

  int get finalAmount {
    if (discountPercent != null) {
      return amount - (amount * discountPercent! ~/ 100);
    }
    if (discountFixed != null) {
      return amount - discountFixed!;
    }
    return amount;
  }
}

class MonthlyFeeConfig {
  final String schoolId;
  final String level;
  final List<MonthlyFeeOption> options;

  const MonthlyFeeConfig({
    required this.schoolId,
    required this.level,
    required this.options,
  });
}
