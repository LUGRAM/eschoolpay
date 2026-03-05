import '../models/cantine_option_model.dart';

final List<CantineOption> cantineOptions = [
  // École Primaire Saint-Joseph
  CantineOption(
    schoolId: 'sch_1',
    label: '1 mois',
    durationInDays: 30,
    amount: 25000,
    note: 'Forfait mensuel',
  ),
  CantineOption(
    schoolId: 'sch_1',
    label: '3 mois',
    durationInDays: 90,
    amount: 70000,
    note: 'Économisez 5000 FCFA',
  ),
  CantineOption(
    schoolId: 'sch_1',
    label: 'Année complète',
    durationInDays: 270,
    amount: 200000,
    note: 'Meilleure offre - Économisez 25000 FCFA',
  ),

  // Collège Moderne
  CantineOption(
    schoolId: 'sch_2',
    label: '1 mois',
    durationInDays: 30,
    amount: 30000,
  ),
  CantineOption(
    schoolId: 'sch_2',
    label: '3 mois',
    durationInDays: 90,
    amount: 85000,
    note: 'Économisez 5000 FCFA',
  ),
  CantineOption(
    schoolId: 'sch_2',
    label: 'Semestre',
    durationInDays: 180,
    amount: 160000,
    note: 'Économisez 20000 FCFA',
  ),

  // Lycée Technique
  CantineOption(
    schoolId: 'sch_3',
    label: '1 mois',
    durationInDays: 30,
    amount: 35000,
  ),
  CantineOption(
    schoolId: 'sch_3',
    label: '3 mois',
    durationInDays: 90,
    amount: 100000,
    note: 'Économisez 5000 FCFA',
  ),
  CantineOption(
    schoolId: 'sch_3',
    label: 'Année complète',
    durationInDays: 270,
    amount: 280000,
    note: 'Économisez 35000 FCFA',
  ),
];
