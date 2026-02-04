import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/widgets/app_button.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

// features/auth/presentation/pages/phone_signup_page.dart
class PhoneSignupPage extends StatelessWidget {
  const PhoneSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Color(0xFF063D66))),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bienvenue !", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF063D66))),
            const SizedBox(height: 10),
            const Text("Entrez votre numéro pour créer votre compte.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            _buildPhoneField(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF063D66),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Get.offAllNamed(Routes.home),
                child: const Text("Continuer", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: const TextField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "+241 74 00 00 00",
          prefixIcon: Icon(Icons.phone_iphone_rounded, color: Color(0xFF063D66)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }
}




















/*
class PhoneSignupPage extends StatefulWidget {
  const PhoneSignupPage({super.key});

  @override
  State<PhoneSignupPage> createState() => _PhoneSignupPageState();
}

class _PhoneSignupPageState extends State<PhoneSignupPage> {
  final _phoneCtrl = TextEditingController(text: '+241 74000001');

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Besoin d’aide?')),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Numéro de téléphone',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                "Veuillez saisir votre numéro de téléphone\npour continuer",
                style: TextStyle(color: Colors.black54, height: 1.35),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneCtrl,
                hint: '+241 …',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_rounded),
              ),
              const Spacer(),
              AppButton(
                label: "S'inscrire",
                onTap: () {
                  auth.phone.value = _phoneCtrl.text.trim();
                  Get.offAllNamed(Routes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/