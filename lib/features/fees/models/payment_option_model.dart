import 'discount_model.dart';

class PaymentOptionModel {
  final String id;
  final int durationInMonths; // 1, 3, 6
  final int amount; // montant total à payer
  final DiscountModel? discount;

  const PaymentOptionModel({
    required this.id,
    required this.durationInMonths,
    required this.amount,
    this.discount,
  });

  bool get hasDiscount => discount != null;
}
