import '../models/frais_scolaire_model.dart';

/// Données simulées pour le service Cours d'Informatique.
/// Utilisées comme fallback quand l'API ne retourne pas encore de résultats
/// (type=INFORMATIQUE non configuré côté backend).
final List<FraisScolaireModel> mockInformatiqueOptions = [
  FraisScolaireModel(
    id: '1001',
    ecoleId: '',
    niveauId: '1',
    anneeScolaireId: '1',
    libelle: 'Débutant · Initiation à l\'informatique',
    montant: 5000,
    montantReduction: null,
  ),
  FraisScolaireModel(
    id: '1002',
    ecoleId: '',
    niveauId: '2',
    anneeScolaireId: '1',
    libelle: 'Intermédiaire · Programmation & Web',
    montant: 8000,
    montantReduction: 500,
  ),
  FraisScolaireModel(
    id: '1003',
    ecoleId: '',
    niveauId: '3',
    anneeScolaireId: '1',
    libelle: 'Avancé · Développement d\'applications',
    montant: 12000,
    montantReduction: 1000,
  ),
];
