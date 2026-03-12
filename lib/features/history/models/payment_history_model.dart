// features/history/models/payment_history_model.dart

enum PaymentServiceType { inscription, mensualite, cantine, transport }

enum PaymentStatus { success, pending, failed }

class PaymentHistory {
  final String id;
  final String childName;
  final String childId;
  final PaymentServiceType service;
  final int amount;
  final DateTime date;
  final String method;
  final PaymentStatus status;
  final String schoolName;
  final String grade;

  PaymentHistory({
    required this.id,
    required this.childName,
    required this.childId,
    required this.service,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
    this.schoolName = '',
    this.grade = '',
  });

  bool get success => status == PaymentStatus.success;

  // ─── Depuis GET /api/inscriptions ───────────────────────────
  factory PaymentHistory.fromInscriptionApi(Map<String, dynamic> json) {
    final eleve = json['eleve'] as Map<String, dynamic>? ?? {};
    final niveau = json['niveau'] as Map<String, dynamic>? ?? {};
    final ecole = json['ecole'] as Map<String, dynamic>? ?? {};

    return PaymentHistory(
      id: json['id'].toString(),
      childId: eleve['id']?.toString() ?? '',
      childName: '${eleve['prenom'] ?? ''} ${eleve['nom'] ?? ''}'.trim(),
      service: PaymentServiceType.inscription,
      amount: (json['fraisInscription'] as num?)?.toInt() ?? 0,
      date: DateTime.tryParse(json['dateInscription'] ?? '') ?? DateTime.now(),
      method: 'Mobile Money',
      status: PaymentStatus.success,
      schoolName: ecole['nom']?.toString() ?? '',
      grade: niveau['nom']?.toString() ?? '',
    );
  }

  // ─── Depuis GET /api/frais-scolaires (source temporaire) ────
  // ⚠️ Représente les frais configurés, pas un paiement confirmé.
  // À remplacer par un vrai endpoint /paiements quand disponible.
  factory PaymentHistory.fromFraisScolairesApi(
      Map<String, dynamic> json, {
        required String childName,
        required String childId,
        required String schoolName,
        required String grade,
      }) {
    return PaymentHistory(
      id: 'frais-${json['id']}',
      childId: childId,
      childName: childName,
      service: PaymentServiceType.mensualite,
      amount: double.tryParse(json['montant']?.toString() ?? '0')?.toInt() ?? 0,
      // created_at comme date de référence
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      method: 'Mobile Money',
      // Frais configurés = disponible, pas encore payé → pending
      status: PaymentStatus.pending,
      schoolName: schoolName,
      grade: grade,
    );
  }
}