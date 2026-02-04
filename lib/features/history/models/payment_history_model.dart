enum PaymentServiceType { inscription, mensualite, cantine, transport }

class PaymentHistory {
  final String id;
  final String childName;
  final PaymentServiceType service;
  final int amount;
  final DateTime date;
  final String method;
  final bool success;

  PaymentHistory({
    required this.id,
    required this.childName,
    required this.service,
    required this.amount,
    required this.date,
    required this.method,
    required this.success,
  });
}
