// features/fees/pages/payment_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../history/controllers/payment_history_controller.dart';
import '../../history/models/payment_history_model.dart';
import '../controllers/fees_controller.dart';
import '../controllers/registration_controller.dart';
import '../services/payment_service.dart';

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
  //String _loadingLabel = "Traitement...";
  Timer? _paymentTimer;
  static const int _maxAttempts = 48; // 36 × 5s = 3 minutes

  @override
  void dispose() {
    _paymentTimer?.cancel();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              // HEADER
              Text(
                paymentContext == PaymentContext.inscription
                    ? "INSCRIPTION"
                    : "PAIEMENT",
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
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Text("Montant à régler",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
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
                child: Text("Mode de paiement",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              const SizedBox(height: 12),
              _methodTile("Airtel Money", Icons.phone_android),
              const SizedBox(height: 8),
              _methodTile("Moov Money", Icons.phone_iphone),

              const SizedBox(height: 24),

              // CHAMP TÉLÉPHONE
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

              const SizedBox(height: 24),

              // ── INFO ATTENTE paiement mobile ─────────────────

              // BOUTON PAYER
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  label: loading ? "En cours..." : "Payer maintenant",
                  loading: loading,
                  onTap: loading
                      ? null
                      : () => _processPayment(paymentContext),
                ),
              ),

              SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Détection du contexte ───────────────────────────────────
  PaymentContext _detectContext() {
    if (Get.isRegistered<RegistrationController>()) {
      final regCtrl = Get.find<RegistrationController>();
      if (regCtrl.selectedChild.value != null) {
        return PaymentContext.inscription;
      }
    }
    return PaymentContext.fees;
  }

  // ─── Montant ─────────────────────────────────────────────────
  int _getAmount(PaymentContext context) {
    final args = Get.arguments ?? {};
    if (context == PaymentContext.inscription) {
      return args['amount'] ?? 0;
    }
    return Get.find<FeesController>().totalAmount;
  }

  // ─── Validation téléphone ────────────────────────────────────
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Numéro de téléphone requis";
    }
    final clean = value.replaceAll(' ', '');
    if (method == 'Airtel Money') {
      if (!clean.startsWith('07')) return "Doit commencer par 07";
      if (clean.length != 9) return "Le numéro doit avoir 9 chiffres";
    } else if (method == 'Moov Money') {
      if (!clean.startsWith('06')) return "Doit commencer par 06";
      if (clean.length != 9) return "Le numéro doit avoir 9 chiffres";
    }
    return null;
  }

  String _getPhoneHint() {
    return method == 'Airtel Money' ? "07x xx xx xx" : "06x xx xx xx";
  }

  // ─── Lancement paiement ──────────────────────────────────────
  Future<void> _processPayment(PaymentContext context) async {
    FocusScope.of(this.context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    //  _loadingLabel = "Initialisation du paiement...";
    });

    if (context == PaymentContext.inscription) {
      await _handleInscriptionPayment();
    } else {
      await _handleFeesPayment();
    }
  }

  // ─── INSCRIPTION ─────────────────────────────────────────────
  Future<void> _handleInscriptionPayment() async {
    final regCtrl = Get.find<RegistrationController>();
    final child = regCtrl.selectedChild.value;
    final amount = Get.arguments?['amount'] ?? 0;

    // Récupère school/grade depuis RegistrationController
    String schoolName = '';
    String grade = '';
    try {
      final sc = Get.find(tag: 'SchoolsController');
      schoolName = sc.selectedSchool.value?.name ?? '';
      grade = sc.selectedLevel.value?.name ?? '';
    } catch (_) {}

    //setState(() => _loadingLabel = "Enregistrement de l'inscription...");

    try {
      await regCtrl.confirmRegistration();
    } catch (e) {
      _stopLoading();
      Get.snackbar("Erreur", "Impossible d'enregistrer l'inscription.");
      return;
    }

    // Ajout à l'historique
    _addToHistory(PaymentHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: child?.id ?? '',
      childName: child?.fullName ?? '',
      service: PaymentServiceType.inscription,
      amount: amount is int ? amount : (amount as num).toInt(),
      date: DateTime.now(),
      method: method,
      status: PaymentStatus.success,
      schoolName: schoolName,
      grade: grade,
    ));

    _stopLoading();

    Get.offNamed(Routes.feesSuccess, arguments: {
      'status': 'SUCCESS',
      'childName': child?.fullName ?? 'N/A',
      'feeLabel': 'Inscription scolaire',
      'amount': amount,
      'method': method,
      'date': DateTime.now(),
    });
  }

  // ─── FRAIS SCOLAIRES ─────────────────────────────────────────
  Future<void> _handleFeesPayment() async {
    final feesCtrl = Get.find<FeesController>();
    final service = PaymentService();

    final child = feesCtrl.selectedChild.value!;
    final frais = feesCtrl.selectedFraisScolaire.value != null ? feesCtrl.selectedFraisScolaire.value!
        : (feesCtrl.selectedCantineOption.value ?? feesCtrl.selectedTransportOption.value) ;

    //setState(() => _loadingLabel = "Envoi de la demande de paiement...");

    print("=========== Affichage =================");
    print(child.id.toString());
    print(feesCtrl.selectedSchoolYearId.value.toString());
    print(frais!.id.toString());
    print(feesCtrl.totalAmount.toDouble());
    final response = await service.payerFrais(
      eleveId: int.parse(child.id.toString()),
      anneeId: int.parse(feesCtrl.selectedSchoolYearId.value.toString()),
      fraisId: int.parse(frais.id.toString()),
      montant: feesCtrl.totalAmount.toDouble(),
      methode: method,
      telephone: phoneCtrl.text,
    );

    debugPrint("Réponse initiale paiement: $response");

    // Erreur à l'envoi → on arrête immédiatement
    if (response['status'] != true || response['statut'] != "PENDING") {
      _stopLoading();
      _navigateToResult('FAILED', child.fullName, frais.libelle,
          feesCtrl.totalAmount);
      return;
    }

    // ── Polling jusqu'à confirmation claire ─────────────────
    //setState(() => _loadingLabel =
    //"En attente de confirmation sur votre téléphone...");

    final reference = response['reference'].toString();
    int attempts = 0;

    _paymentTimer?.cancel();
    _paymentTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
          attempts++;

          final result = await service.check(reference);
          final String? status = result['status']?.toString();

          debugPrint("Check paiement [$attempts/$_maxAttempts]: $status");

          if (status == 'PAYED') {
            timer.cancel();

            _addToHistory(PaymentHistory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              childId: child.id ?? '',
              childName: child.fullName,
              service: PaymentServiceType.mensualite,
              amount: feesCtrl.totalAmount,
              date: DateTime.now(),
              method: method,
              status: PaymentStatus.success,
              schoolName: child.extras['school_name'] ?? '',
              grade: child.extras['grade'] ?? '',
            ));

            _stopLoading();
            _navigateToResult(
                'SUCCESS', child.fullName, frais.libelle, feesCtrl.totalAmount);
            return;
          }

          if (status == 'FAILED') {
            timer.cancel();
            _stopLoading();
            _navigateToResult(
                'FAILED', child.fullName, frais.libelle, feesCtrl.totalAmount);
            return;
          }

          // Timeout → on informe sans bloquer
          if (attempts >= _maxAttempts) {
            timer.cancel();
            _stopLoading();
            Get.snackbar(
              "Paiement en attente",
              "La confirmation prend trop de temps. Vérifiez votre téléphone.",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 6),
            );
          }
        });
  }

  // ─── Helpers ─────────────────────────────────────────────────
  void _stopLoading() {
    if (mounted) setState(() => loading = false);
  }

  void _navigateToResult(
      String status, String childName, String feeLabel, int amount) {
    Get.offNamed(Routes.feesSuccess, arguments: {
      'status': status,
      'childName': childName,
      'feeLabel': feeLabel,
      'amount': amount,
      'method': method,
      'date': DateTime.now(),
    });
  }

  void _addToHistory(PaymentHistory record) {
    if (Get.isRegistered<PaymentHistoryController>()) {
      Get.find<PaymentHistoryController>().addHistory(record);
    }
  }

  // ─── Tile mode paiement ──────────────────────────────────────
  Widget _methodTile(String name, IconData icon) {
    final isSelected = method == name;
    return GestureDetector(
      onTap: () => setState(() {
        method = name;
        phoneCtrl.clear();
      }),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
            isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Text(name,
                style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── Formateur téléphone gabonais ────────────────────────────
class LibellePhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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