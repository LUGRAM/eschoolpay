// lib/features/fees/models/transport_option_model.dart

class TransportOption {
  final String schoolId;
  final String label; // Ex: "1 mois", "Trimestre"
  final String zone; // Ex: "Zone 1 (Libreville centre)"
  final int durationInDays;
  final int amount;
  final String? note;

  TransportOption({
    required this.schoolId,
    required this.label,
    required this.zone,
    required this.durationInDays,
    required this.amount,
    this.note,
  });
}