import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    // Détection automatique du contexte
    final PaymentContext paymentContext = _detectContext();
    final int amount = _getAmount(paymentContext);
    final String title = paymentContext == PaymentContext.inscription
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView( // ✅ AJOUT DU SCROLL
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT pour le scroll
            children: [
              const SizedBox(height: 20),

              // HEADER
              Text(
                paymentContext == PaymentContext.inscription ? "INSCRIPTION" : "PAIEMENT",
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

              // TÉLÉPHONE (conditionnel)
              if (method != 'Espèces') ...[
                AppTextField(
                  hint: _getPhoneHint(),
                  prefixIcon: const Icon(Icons.phone),
                  keyboardType: TextInputType.phone,
                  controller: phoneCtrl,
                  validator: _validatePhone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LibellePhoneFormatter(),
                  ],
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Veuillez vous présenter à la comptabilité de l'école pour régler ce montant. "
                              "Nous validerons votre inscription immédiatement après le paiement.",
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // BOUTON PAYER (maintenant dans le scroll)
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  label: loading
                      ? "Traitement..."
                      : (method == 'Espèces' ? "Confirmer l'inscription" : "Payer maintenant"),
                  loading: loading,
                  onTap: loading ? null : () => _processPayment(paymentContext),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20), // ✅ Espace pour le clavier
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────
  // DÉTECTION DU CONTEXTE
  // ─────────────────────────────────────────────────────
  PaymentContext _detectContext() {
    if (Get.isRegistered<RegistrationController>()) {
      final regCtrl = Get.find<RegistrationController>();
      if (regCtrl.selectedChild.value != null) {
        return PaymentContext.inscription;
      }
    }

    if (Get.isRegistered<FeesController>()) {
      return PaymentContext.fees;
    }

    return PaymentContext.fees;
  }

  // ─────────────────────────────────────────────────────
  // RÉCUPÉRATION DU MONTANT
  // ─────────────────────────────────────────────────────
  int _getAmount(PaymentContext context) {
    final args = Get.arguments ?? {};

    if (context == PaymentContext.inscription) {
      return args['amount'] ?? 25000; // valeur temporaire si non fourni
    } else {
      final feesCtrl = Get.find<FeesController>();
      return feesCtrl.totalAmount;
    }
  }
  // ─────────────────────────────────────────────────────
  // VALIDATION DU NUMÉRO DE TÉLÉPHONE
  // ─────────────────────────────────────────────────────
  String? _validatePhone(String? value) {
    if (method == 'Espèces') return null;

    if (value == null || value.trim().isEmpty) {
      return "Numéro de téléphone requis";
    }

    // On nettoie la valeur pour la validation logique
    final cleanPhone = value.replaceAll(' ', '');

    if (method == 'Airtel Money') {
      if (!cleanPhone.startsWith('07')) return "Doit commencer par 07";
      if (cleanPhone.length != 9) return "Le numéro doit avoir 9 chiffres";
    } else if (method == 'Moov Money') {
      if (!cleanPhone.startsWith('06')) return "Doit commencer par 06";
      if (cleanPhone.length != 9) return "Le numéro doit avoir 9 chiffres";
    }

    return null;
  }

  // ─────────────────────────────────────────────────────
  // HINT DU CHAMP TÉLÉPHONE
  // ─────────────────────────────────────────────────────
  String _getPhoneHint() {
    if (method == 'Airtel Money') {
      return "07x xx xx xx";
    } else if (method == 'Moov Money') {
      return "06x xx xx xx";
    }
    return "Numéro de téléphone";
  }

  // ─────────────────────────────────────────────────────
  // TRAITEMENT DU PAIEMENT
  // ─────────────────────────────────────────────────────
  Future<void> _processPayment(PaymentContext context) async {
    FocusScope.of(this.context).unfocus();

    if (method != 'Espèces') {
      if (!_formKey.currentState!.validate()) return;
    }

    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (context == PaymentContext.inscription) {
      await _handleInscriptionPayment();
    } else {
      await _handleFeesPayment();
    }
  }
  Future<void> _handleInscriptionPayment() async {
    final regCtrl = Get.find<RegistrationController>();

    await regCtrl.confirmRegistration();

    setState(() => loading = false);

    Get.offNamed(
      Routes.feesSuccess,
      arguments: {
        'status': method == 'Espèces' ? 'PENDING' : 'SUCCESS',
        'service': 'inscription',
        'method': method,
      },
    );
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
      onTap: () {
        setState(() {
          method = name;
          phoneCtrl.clear(); // Réinitialise le numéro lors du changement
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
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

/// Formateur de téléphone gabonais (9 chiffres avec espaces)
class LibellePhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', ''); // On travaille sans les espaces
    if (text.length > 9) return oldValue; // Limite à 9 chiffres (format Gabon)

    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      // Ajoute un espace après le 3ème, 5ème et 7ème chiffre
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