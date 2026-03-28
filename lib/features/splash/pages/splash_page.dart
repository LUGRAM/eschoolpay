import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../app/router/routes.dart';

// features/auth/presentation/pages/splash_page.dart
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  // pour rediriger toujours vers la page d'onboarding après 3 secondes
  /*
  @override
  void initState() {
    super.initState();
    // Utilise GetX pour la navigation
    Future.delayed(
        const Duration(seconds: 3), () => Get.offNamed(Routes.onboarding));
  }

   */

  /// pour afficher le splash qu'une seule fois

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _redirect);
  }

  void _redirect() {
    final box = GetStorage();
    final token = box.read('auth_token') ?? box.read('token');

    if (token != null && token.toString().isNotEmpty) {
      // Token présent → directement home
      Get.offAllNamed(Routes.home);
    } else {
      // Pas de token → onboarding
      Get.offNamed(Routes.onboarding);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            colors: [
              Color(0xFF053D66), // zone très foncée prolongée
              Color(0xFF053D66), // encore du foncé (jusqu'au logo)
              Color(0xFF013F68), // début du changement après le logo
              Color(0xFF306C94), // bleu clair
            ],

            stops: [
              0.0, // début
              0.50, // couleur stable jusqu'au milieu
              0.60, // transition douce juste après le logo
              0.90, // final très progressif
            ],
          ),
        ),

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 110,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Bantu SchoolPay",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Times New Roman",
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Payez les études de vos enfant en toutes sécurité",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Times New Roman",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}










/*
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.onboarding);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF053d66),
              Color(0xFF053d66),
              Color(0xFF013F68),
              Color(0xFF306C94),
            ],
            stops: [
              0.0,
              0.50,
              0.55,
              0.85,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 110,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Bantu SchoolPay",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Times New Roman",
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Payez les études de vos enfant en toutes sécurité",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Times New Roman",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.school_rounded, color: Colors.white, size: 52),
            SizedBox(height: 12),
            Text(
              'Bantu SchoolPay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Payez les études de vos enfants en toute sécurité',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
*/