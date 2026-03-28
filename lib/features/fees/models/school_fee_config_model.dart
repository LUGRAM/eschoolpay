import 'payment_option_model.dart';

class SchoolFeeConfigModel {
  final String schoolId;
  final String cycle; // Collège / Lycée
  final List<PaymentOptionModel> paymentOptions;

  const SchoolFeeConfigModel({
    required this.schoolId,
    required this.cycle,
    required this.paymentOptions,
  });
}
