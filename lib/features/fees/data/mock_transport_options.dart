// lib/features/fees/data/mock_transport_options.dart

import '../models/transport_option_model.dart';

final List<TransportOption> transportOptions = [
  // ───────────────── Lycée Léon Mba ─────────────────
  TransportOption(
    schoolId: 'sch_1',
    label: '1 mois',
    zone: 'Zone 1 (Libreville centre)',
    durationInDays: 30,
    amount: 40000,
    note: 'Aller-retour quotidien',
  ),
  TransportOption(
    schoolId: 'sch_1',
    label: '3 mois',
    zone: 'Zone 1 (Libreville centre)',
    durationInDays: 90,
    amount: 115000,
    note: 'Économisez 5000 FCFA',
  ),
  TransportOption(
    schoolId: 'sch_1',
    label: 'Semestre',
    zone: 'Zone 1 (Libreville centre)',
    durationInDays: 180,
    amount: 220000,
    note: 'Économisez 20000 FCFA',
  ),
  TransportOption(
    schoolId: 'sch_1',
    label: '1 mois',
    zone: 'Zone 2 (Banlieue)',
    durationInDays: 30,
    amount: 50000,
    note: 'Aller-retour quotidien',
  ),
  TransportOption(
    schoolId: 'sch_1',
    label: '3 mois',
    zone: 'Zone 2 (Banlieue)',
    durationInDays: 90,
    amount: 145000,
    note: 'Économisez 5000 FCFA',
  ),

  // ───────────────── CES Akébé ─────────────────
  TransportOption(
    schoolId: 'sch_2',
    label: '1 mois',
    zone: 'Zone unique',
    durationInDays: 30,
    amount: 35000,
  ),
  TransportOption(
    schoolId: 'sch_2',
    label: '3 mois',
    zone: 'Zone unique',
    durationInDays: 90,
    amount: 100000,
    note: 'Économisez 5000 FCFA',
  ),
  TransportOption(
    schoolId: 'sch_2',
    label: 'Année complète',
    zone: 'Zone unique',
    durationInDays: 270,
    amount: 315000,
    note: 'Meilleure offre',
  ),
];