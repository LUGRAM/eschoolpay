import 'package:flutter/material.dart';
import '../../fees/models/frais_scolaire_model.dart';

class InformatiqueOption {
  final String? id;
  final String niveau;
  final String titre;
  final String description;
  final double montant;
  final double? reduction;
  final String duree;
  final IconData icon;
  final String? badge;
  final List<String> features;
  final bool isHighlighted;

  const InformatiqueOption({
    this.id,
    required this.niveau,
    required this.titre,
    required this.description,
    required this.montant,
    this.reduction,
    required this.duree,
    required this.icon,
    this.badge,
    this.features = const [],
    this.isHighlighted = false,
  });

  factory InformatiqueOption.fromFrais(FraisScolaireModel frais) {
    final lower = frais.libelle.toLowerCase();
    String niveau;
    String titre;
    String description;
    IconData icon;
    String? badge;
    List<String> features;
    bool isHighlighted;

    if (lower.contains('avancé') || lower.contains('avance')) {
      niveau = 'Avancé';
      titre = _extractTitre(frais.libelle);
      if (titre.isEmpty || lower == titre.toLowerCase()) {
        titre = 'Développement d\'applications';
      }
      description =
          'Maîtrisez Flutter, Firebase et les APIs REST. Déployez vos propres applications sur le Play Store.';
      icon = Icons.developer_mode_rounded;
      badge = 'Certification offerte';
      features = [
        'Flutter & Dart',
        'APIs REST & JSON',
        'Firebase & Cloud',
        'Publication Play Store',
      ];
      isHighlighted = true;
    } else if (lower.contains('intermédiaire') ||
        lower.contains('intermediaire')) {
      niveau = 'Intermédiaire';
      titre = _extractTitre(frais.libelle);
      if (titre.isEmpty || lower == titre.toLowerCase()) {
        titre = 'Programmation & Web';
      }
      description =
          'Créez vos premières pages web dynamiques avec HTML, CSS et JavaScript moderne.';
      icon = Icons.code_rounded;
      badge = 'Plus populaire';
      features = [
        'HTML & CSS3',
        'JavaScript ES6+',
        'Git & GitHub',
        'Responsive Design',
      ];
      isHighlighted = false;
    } else {
      niveau = 'Débutant';
      titre = _extractTitre(frais.libelle);
      if (titre.isEmpty || lower == titre.toLowerCase()) {
        titre = 'Bases de l\'informatique';
      }
      description =
          'Découvrez l\'univers numérique : bureautique, internet, sécurité et outils essentiels du quotidien.';
      icon = Icons.laptop_outlined;
      badge = null;
      features = [
        'Bureautique & Office',
        'Navigation web',
        'Sécurité numérique',
        'Dactylographie',
      ];
      isHighlighted = false;
    }

    return InformatiqueOption(
      id: frais.id,
      niveau: niveau,
      titre: titre,
      description: description,
      montant: frais.montant,
      reduction: frais.montantReduction,
      duree: '1 semaine',
      icon: icon,
      badge: badge,
      features: features,
      isHighlighted: isHighlighted,
    );
  }

  // Extrait le titre après un séparateur (·, —, –, -, :)
  static String _extractTitre(String libelle) {
    for (final sep in ['·', '—', '–', '-', ':']) {
      if (libelle.contains(sep)) {
        final parts = libelle.split(sep);
        if (parts.length > 1) return parts.last.trim();
      }
    }
    return libelle.trim();
  }
}
