import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import 'build_year_selector.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});


  @override
  Widget build(BuildContext context) {
    // On déplace ici toute la Column qui était dans ton body
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildYearSelector(), // À transformer en widget ou méthode statique
              const SizedBox(height: 25),
              _buildQuickActions(),
              const SizedBox(height: 25),
              const Text("Derniers paiements",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildPaymentList(),
          ),
        ),
      ],
    );
  }
}

Widget _buildQuickActions() {
  return Row(
    children: [
      _actionCard(
        "Mes enfants",
        Icons.child_care,
        const Color(0xFFE3F2FD),
            () =>
            Get.toNamed(Routes.childrenList), // Redirige vers ta page children_list_page.dart
      ),
      const SizedBox(width: 15),
      _actionCard(
        "Nos services",
        Icons.business_center,
        const Color(0xFFF3E5F5),
            () =>
            Get.toNamed(Routes.servicesMenu), // Redirection vers le menu des 4 services
      ),
    ],
  );
}

Widget _actionCard(String title, IconData icon, Color bg,
    VoidCallback onTap) {
  return Expanded(
    child: InkWell( // Utilisation de InkWell pour l'effet de clic (ripple effect)
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withValues(alpha:0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
                backgroundColor: bg,
                radius: 25,
                child: Icon(icon, color: const Color(0xFF063D66))
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPaymentList() {
  final Color primaryBlue = const Color(0xFF063D66);

  return Column(
    children: List.generate(4, (index) =>
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF4F7F9),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.description_outlined, color: primaryBlue),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Frais de scolarité",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("0${index + 1}/09/2024", style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              Text("45 000 FCFA", style: TextStyle(
                  color: primaryBlue, fontWeight: FontWeight.bold)),
            ],
          ),
        )),
  );
}
