class FraisScolaireModel {
  final String? id;
  final String ecoleId;
  final String niveauId;
  final String anneeScolaireId;

  final String libelle;

  final double montant;
  final double? pourcentageReduction;
  final double? montantReduction;

  FraisScolaireModel({
    this.id,
    required this.ecoleId,
    required this.niveauId,
    required this.anneeScolaireId,
    required this.libelle,
    required this.montant,
    this.pourcentageReduction,
    this.montantReduction,
  });

  /// JSON → Model
  factory FraisScolaireModel.fromJson(Map<String, dynamic> json) {
    return FraisScolaireModel(
      id: json['id']?.toString(),
      ecoleId: json['ecole_id']?.toString() ?? '',
      niveauId: json['niveau_id']?.toString() ?? '',
      anneeScolaireId: json['annee_scolaire_id']?.toString() ?? '',
      libelle: json['libelle'] ?? '',
      montant: double.tryParse(json['montant'].toString()) ?? 0,
      pourcentageReduction: json['pourcentage_reduction'] != null
          ? double.tryParse(json['pourcentage_reduction'].toString())
          : null,
      montantReduction: json['montant_reduction'] != null
          ? double.tryParse(json['montant_reduction'].toString())
          : null,
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "ecole_id": ecoleId,
      "niveau_id": niveauId,
      "annee_scolaire_id": anneeScolaireId,
      "libelle": libelle,
      "montant": montant,
      "pourcentage_reduction": pourcentageReduction,
      "montant_reduction": montantReduction,
    };
  }
}