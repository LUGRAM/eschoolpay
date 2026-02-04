enum DiscountType {
  percentage,
  fixedAmount,
}

class DiscountModel {
  final DiscountType type;
  final int value; // % ou montant FCFA
  final String label; // ex: "Économie 10 %"

  const DiscountModel({
    required this.type,
    required this.value,
    required this.label,
  });
}
