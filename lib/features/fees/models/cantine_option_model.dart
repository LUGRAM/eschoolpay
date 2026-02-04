class CantineOption {
  final String schoolId;
  final String label; // Ex: "1 mois", "3 mois"
  final int durationInDays;
  final int amount;
  final String? note; // ✅ Ajout de la propriété manquante

  CantineOption({
    required this.schoolId,
    required this.label,
    required this.durationInDays,
    required this.amount,
    this.note, // ✅ Optionnel
  });
}