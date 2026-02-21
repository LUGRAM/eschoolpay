import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart'; // ✅ ajuste le chemin selon ton projet

class PhoneSigninPage extends StatefulWidget {
  const PhoneSigninPage({super.key});

  @override
  State<PhoneSigninPage> createState() => _PhoneSigninPageState();
}

class _PhoneSigninPageState extends State<PhoneSigninPage> {
  final _phoneCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  late final AuthController _authCtrl;

  @override
  void initState() {
    super.initState();
    _authCtrl = Get.find<AuthController>(); // ✅ connecté au controller
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.primary, size: 32),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bon retour !",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF063D66),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Entrez votre numéro pour vous connecter.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            const Text(
              "Numéro de téléphone",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            AppTextField(
              hint: "07x xx xx xx",
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              controller: _phoneCtrl,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LibellePhoneFormatter(),
              ],
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _isLoading ? null : _handleSignin,
                child: _isLoading
                    ? const SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Text(
                  "Se connecter",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pas encore de compte ? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offNamed(Routes.phoneSignup);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primarySoft,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
          ],
        ),
      ),
    );
  }

  String? _validatePhone(String value) {
    if (value.trim().isEmpty) return "Numéro de téléphone requis";

    final cleanPhone = value.replaceAll(' ', '');
    if (cleanPhone.length != 9) return "Le numéro doit contenir 9 chiffres";

    final validPrefixes = ['077', '066', '065', '074', '011', '062'];
    final prefix = cleanPhone.substring(0, 3);

    if (!validPrefixes.contains(prefix)) return "Numéro incorrect";
    return null;
  }

  Future<void> _handleSignin() async {
    FocusScope.of(context).unfocus();

    final error = _validatePhone(_phoneCtrl.text);

    setState(() => _errorMessage = error);
    if (error != null) return;

    setState(() => _isLoading = true);

    final fullPhone = _phoneCtrl.text.replaceAll(' ', '');

    try {
      // ✅ Appel réel au controller (login)
      // NOTE: ton backend login demande password.
      // Si tu veux "phone-only", il faut changer l’API en OTP / code.
      // Ici on redirige vers la page password/otp si tu en as une.
      final ok = await _authCtrl.login(phone: fullPhone, password: ""); // ⚠️ à remplacer (OTP / password)

      if (ok) {
        Get.offAllNamed(Routes.home, arguments: {'phone': fullPhone});
      } else {
        setState(() => _errorMessage = "Connexion impossible. Vérifie tes informations.");
      }
    } catch (_) {
      setState(() => _errorMessage = "Erreur réseau. Réessaie.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Formateur de téléphone gabonais (9 chiffres avec espaces)
class LibellePhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 9) return oldValue;

    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      if ((i == 2 || i == 4 || i == 6) && i != text.length - 1) {
        formatted += ' ';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}