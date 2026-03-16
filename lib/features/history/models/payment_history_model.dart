// features/history/models/payment_history_model.dart

enum PaymentServiceType { inscription, mensualite, cantine, transport }

enum PaymentStatus { success, pending, failed }

class PaymentHistory {
  final String id;
  final String childName;
  final String childId;
  final String matricule;
  final PaymentServiceType service;
  final int amount;
  final DateTime date;
  final String method;
  final PaymentStatus status;
  final String schoolName;
  final String grade;
  final String? reference; // uniquement pour les transactions

  PaymentHistory({
    required this.id,
    required this.childName,
    required this.childId,
    this.matricule = '',
    required this.service,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
    this.schoolName = '',
    this.grade = '',
    this.reference,
  });

  bool get success => status == PaymentStatus.success;

  // ─── Mapping statut API → enum ───────────────────────────────
  static PaymentStatus _parseStatut(String? s) {
    switch (s?.toUpperCase()) {
      case 'SUCCESS':
      case 'PAYED':
        return PaymentStatus.success;
      case 'PENDING':
        return PaymentStatus.pending;
      case 'FAILED':
      default:
        return PaymentStatus.failed;
    }
  }

  // ─── Depuis inscriptions[] ───────────────────────────────────
  factory PaymentHistory.fromInscriptionApi(Map<String, dynamic> json) {
    final eleve = json['eleve'] as Map<String, dynamic>? ?? {};
    final niveau = json['niveau'] as Map<String, dynamic>? ?? {};
    final ecole = json['ecole'] as Map<String, dynamic>? ?? {};

    return PaymentHistory(
      id: 'ins-${json['id']}',
      childId: eleve['id']?.toString() ?? '',
      childName: '${eleve['prenom'] ?? ''} ${eleve['nom'] ?? ''}'.trim(),
      matricule: eleve['matricule']?.toString() ?? '',
      service: PaymentServiceType.inscription,
      amount: double.tryParse(
          json['frais_inscription']?.toString() ?? '0')
          ?.toInt() ??
          0,
      date: DateTime.tryParse(json['date_inscription'] ?? '') ??
          DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(),
      method: 'N/A',
      status: _parseStatut(json['statut']),
      schoolName: ecole['nom']?.toString() ?? '',
      grade: niveau['nom']?.toString() ?? '',
    );
  }

  // ─── Depuis dernieres_transactions[] ────────────────────────
  factory PaymentHistory.fromTransactionApi(Map<String, dynamic> json) {
    final eleve = json['eleve'] as Map<String, dynamic>? ?? {};
    final frais = json['frais_scolaire'] as Map<String, dynamic>? ?? {};

    return PaymentHistory(
      id: 'tx-${json['id']}',
      childId: eleve['id']?.toString() ?? '',
      childName: '${eleve['prenom'] ?? ''} ${eleve['nom'] ?? ''}'.trim(),
      matricule: eleve['matricule']?.toString() ?? '',
      service: PaymentServiceType.mensualite,
      amount: double.tryParse(json['montant']?.toString() ?? '0')
          ?.toInt() ??
          0,
      date: DateTime.tryParse(json['date'] ?? '') ??
          DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(),
      method: json['methode']?.toString() ?? 'Mobile Money',
      status: _parseStatut(json['statut']),
      grade: frais['libelle']?.toString() ?? '',
      reference: json['reference']?.toString(),
    );
  }
}