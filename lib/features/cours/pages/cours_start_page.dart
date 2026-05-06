import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cours_list_page.dart';

/// Point d'entrée du service Cours.
/// Redirige immédiatement vers CoursListPage.
/// Peut être étendu en Phase 2 pour afficher un écran d'accueil/paywall.
class CoursStartPage extends StatelessWidget {
  const CoursStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoursListPage();
  }
}