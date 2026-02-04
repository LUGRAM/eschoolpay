class PaymentRecordModel {
  final String id;
  final String childId;
  final String childName;
  final String feeLabel; // ex: "Mensualité • 3 mois"
  final int amount;
  final String method; // Airtel / Moov / Espèces
  final String status; // SUCCESS / FAILED / PENDING
  final DateTime createdAt;

  const PaymentRecordModel({
    required this.id,
    required this.childId,
    required this.childName,
    required this.feeLabel,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });
}
