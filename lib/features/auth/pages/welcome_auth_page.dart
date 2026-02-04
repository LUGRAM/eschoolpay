import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_button.dart';

class WelcomeAuthPage extends StatelessWidget {
  const WelcomeAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Besoin d’aide?'),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Nouveau sur E-SchoolPay ?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              const Icon(Icons.groups_rounded, size: 90, color: AppColors.primarySoft),
              const SizedBox(height: 18),
              const Text(
                "Inscrivez vous facilement et rapidement\navec votre numéro de téléphone",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, height: 1.35),
              ),
              const Spacer(),
              AppButton(
                label: "Créer mon compte",
                onTap: () => Get.toNamed(Routes.phoneSignup),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
