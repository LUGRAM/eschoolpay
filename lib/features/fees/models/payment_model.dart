class PaymentModel {
  final String id;
  final String childId;
  final String childName;
  final String feeLabel;
  final int amount;
  final String method; // "Airtel Money" / "Moov Money" / "Carte"
  final DateTime createdAt;
  final String status; // "SUCCESS" / "FAILED" / "PENDING"

  PaymentModel({
    required this.id,
    required this.childId,
    required this.childName,
    required this.feeLabel,
    required this.amount,
    required this.method,
    required this.createdAt,
    required this.status,
  });
}
