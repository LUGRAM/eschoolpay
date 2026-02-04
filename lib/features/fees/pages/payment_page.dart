import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/gradient_button.dart';
import '../controllers/fees_controller.dart';
import '../controllers/registration_controller.dart';

enum PaymentContext { inscription, fees }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final phoneCtrl = TextEditingController();
  String method = 'Airtel Money';
  bool loading = false;

  @override
  void dispose() {
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Détection automatique du contexte
    final PaymentContext context = _detectContext();
    final int amount = _getAmount(context);
    final String title = context == PaymentContext.inscription
        ? "Paiement inscription"
        : "Paiement";

    if (amount == 0) {
      return const Scaffold(
        body: Center(child: Text("Erreur : aucune donnée")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(title, style: const TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // HEADER
            Text(
              context == PaymentContext.inscription ? "INSCRIPTION" : "PAIEMENT",
              style: const TextStyle(
                letterSpacing: 2,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 16),

            // MONTANT
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    "Montant à régler",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$amount FCFA",
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // MODES DE PAIEMENT
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mode de paiement",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            _methodTile("Airtel Money", Icons.phone_android),
            const SizedBox(height: 8),
            _methodTile("Moov Money", Icons.phone_iphone),
            const SizedBox(height: 8),
            _methodTile("Espèces", Icons.money),

            const SizedBox(height: 24),

            // TÉLÉPHONE
            AppTextField(
              hint: "07x xx xx xx",
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              controller: phoneCtrl,
            ),

            const Spacer(),

            // BOUTON PAYER
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: loading ? "Traitement..." : "Payer maintenant",
                loading: loading,
                onTap: loading ? null : () => _processPayment(context),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // DÉTECTION DU CONTEXTE
  // ─────────────────────────────────────────────────────
  PaymentContext _detectContext() {
    try {
      final regCtrl = Get.find<RegistrationController>();
      if (regCtrl.selectedFee.value != null) {
        return PaymentContext.inscription;
      }
    } catch (_) {}

    try {
      final feesCtrl = Get.find<FeesController>();
      if (feesCtrl.selected.value != null) {
        return PaymentContext.fees;
      }
    } catch (_) {}

    return PaymentContext.fees; // Défaut
  }

  // ─────────────────────────────────────────────────────
  // RÉCUPÉRATION DU MONTANT
  // ─────────────────────────────────────────────────────
  int _getAmount(PaymentContext context) {
    if (context == PaymentContext.inscription) {
      final regCtrl = Get.find<RegistrationController>();
      return regCtrl.totalAmount.value;
    } else {
      final feesCtrl = Get.find<FeesController>();
      return feesCtrl.totalAmount;
    }
  }

  // ─────────────────────────────────────────────────────
  // TRAITEMENT DU PAIEMENT
  // ─────────────────────────────────────────────────────
  Future<void> _processPayment(PaymentContext context) async {
    // Validation
    if (phoneCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Erreur",
        "Veuillez saisir votre numéro de téléphone",
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulation

    if (context == PaymentContext.inscription) {
      _handleInscriptionPayment();
    } else {
      _handleFeesPayment();
    }
  }

  void _handleInscriptionPayment() {
    final regCtrl = Get.find<RegistrationController>();
    final record = regCtrl.confirmRegistration();

    setState(() => loading = false);

    Get.offNamed(Routes.feesSuccess, arguments: {
      'status': 'SUCCESS',
      'childName': record.childName,
      'feeLabel': 'Inscription ${record.schoolName}',
      'amount': record.amount,
      'method': method,
      'date': record.date,
    });
  }

  Future<void> _handleFeesPayment() async {
    final feesCtrl = Get.find<FeesController>();
    final record = await feesCtrl.payNow(method: method);

    setState(() => loading = false);

    Get.offNamed(Routes.feesSuccess, arguments: {
      'status': record.status,
      'childName': record.childName,
      'feeLabel': record.feeLabel,
      'amount': record.amount,
      'method': record.method,
      'date': record.createdAt,
    });
  }

  // ─────────────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────────────
  Widget _methodTile(String name, IconData icon) {
    final isSelected = method == name;
    return GestureDetector(
      onTap: () => setState(() => method = name),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}