import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

// features/onboarding/presentation/pages/onboarding_page.dart
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: c.skip,
                  child: const Text('Passer', style: TextStyle(color: Color(0xFF063D66)))
              ),
            ),
            Expanded(
              child: PageView(
                controller: c.pageController, // INDISPENSABLE pour le bouton suivant
                onPageChanged: (i) => c.index.value = i,
                children: [
                  _buildSlide(Icons.school_rounded, "Suivi Scolaire", "Accédez aux alertes et informations importantes de l'école."),
                  _buildSlide(Icons.account_balance_wallet_rounded, "Paiement Facile", "Payez la scolarité de vos enfants en quelques clics."),
                  _buildSlide(Icons.security_rounded, "Sécurité Totale", "Vos transactions sont protégées."),
                ],
              ),
            ),
            _buildBottomControls(c),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(OnboardingController c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicateurs (Dots)
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: c.index.value == i ? 24 : 8,
              decoration: BoxDecoration(
                color: c.index.value == i ? const Color(0xFF063D66) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            )),
          )),
          const SizedBox(height: 30),
          // Bouton d'action connecté au Controller
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF063D66),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: c.next, // Appelle la méthode next() du controller
              child: Obx(() => Text(
                c.index.value == 2 ? "C'est parti !" : "Suivant",
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(IconData icon, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: const Color(0xFF063D66)),
          const SizedBox(height: 40),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}









/*
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();

    final slides = const [
      OnboardingSlide(
        icon: Icons.backpack_rounded,
        title: 'Bantu SchoolPay',
        subtitle:
        "Accédez directement à la scolarité de votre école, consultez les alertes de paiement et les informations importantes",
      ),
      OnboardingSlide(
        icon: Icons.payments_rounded,
        title: 'Bantu SchoolPay',
        subtitle: "Un tableau de bord pour gérer vos paiements",
      ),
      OnboardingSlide(
        icon: Icons.groups_rounded,
        title: 'Nouveau sur Bantu SchoolPay ?',
        subtitle:
        "Inscrivez-vous facilement et rapidement avec votre numéro de téléphone",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: c.skip,
                child: const Text('Passer'),
              ),
            ),
            Expanded(
              child: Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: slides[c.index.value],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(() {
                    final i = c.index.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (k) {
                        final active = k == i;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: active ? 22 : 8,
                          decoration: BoxDecoration(
                            color: active ? AppColors.primarySoft : AppColors.border,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        );
                      }),
                    );
                  }),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primarySoft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: c.next,
                      child: Obx(() {
                        return Text(
                          c.index.value < 2 ? 'Suivant' : 'Créer mon compte',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/