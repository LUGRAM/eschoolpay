import 'package:get/get.dart';
import '../../../app/router/routes.dart';

import 'package:flutter/material.dart';

class OnboardingController extends GetxController {
  final index = 0.obs;
  final pageController = PageController();

  void next() {
    if (index.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void skip() {
    // Utilise ta route de login/signup
    Get.offAllNamed(Routes.phoneSignup);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

/*
class OnboardingController extends GetxController {
  final index = 0.obs;

  void next() {
    if (index.value < 2) {
      index.value++;
    } else {
      Get.offAllNamed(Routes.authWelcome);
    }
  }

  void skip() => Get.offAllNamed(Routes.authWelcome);
}
*/