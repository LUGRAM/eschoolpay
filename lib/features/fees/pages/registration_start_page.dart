import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/router/app_pages.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../children/controllers/children_controller.dart';
import '../../history/controllers/payment_history_controller.dart';
import '../../history/models/payment_history_model.dart';
import '../controllers/registration_controller.dart';

class RegistrationStartPage extends StatefulWidget {
  const RegistrationStartPage({super.key});

  @override
  State<RegistrationStartPage> createState() => _RegistrationStartPageState();
}

class _RegistrationStartPageState extends State<RegistrationStartPage> {
  int step = 0;
  final regCtrl = Get.find<RegistrationController>();
  final childrenCtrl = Get.find<ChildrenController>();

  String? selectedLevel;
  String? selectedSchoolName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // 1️⃣ CUSTOM STEPPER HEADER
          _buildPinterestStepper(),

          const SizedBox(height: 20),

          // 2️⃣ CONTENT (On affiche la vue selon le 'step')
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStepContent(),
            ),
          ),
        ],
      ),    );
  }

  Widget _buildCurrentStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _getStepWidget(), // Déplace ton switch ici avec une Key unique
    );
  }

  Widget _getStepWidget() {
    switch (step) {
      case 0:
        return _buildSelection(key: const ValueKey(0));
      case 1:
        return _buildSummarySafe(key: const ValueKey(1));
      case 2:
        return _buildPaymentSafe(key: const ValueKey(2));
      default:
        return const SizedBox.shrink();
    }
  }

// --- LE DESIGN PRO DU STEPPER ---
  Widget _buildPinterestStepper() {
    List<String> labels = ["Sélection", "Résumé", "Paiement"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        bool isPast = step > index;
        bool isCurrent = step == index;

        return Row(
          children: [
            Column(
              children: [
                // La "Boule"
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 32, width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent || isPast ? AppColors.primarySoft : Colors.grey.shade200,
                    boxShadow: isCurrent ? [
                      BoxShadow(color: AppColors.primarySoft.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))
                    ] : [],
                  ),
                  child: Center(
                    child: isPast
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text("${index + 1}",
                        style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold
                        )),
                  ),
                ),
                const SizedBox(height: 8),
                // Nom du Step sous la boule
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                    color: isCurrent ? AppColors.textPrimary : Colors.grey,
                  ),
                ),
              ],
            ),
            // Ligne de liaison entre les boules
            if (index < labels.length - 1)
              Container(
                width: 50,
                height: 2,
                margin: const EdgeInsets.only(bottom: 20), // Aligné avec les boules
                color: isPast ? AppColors.primarySoft : Colors.grey.shade200,
              ),
          ],
        );
      }),
    );
  }

  // ================== ÉTAPE 1 - CORRIGÉE ==================
  Widget _buildSelection({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─────────────────────────────────────────────────────
        // 1️⃣ SÉLECTION ENFANT
        // ─────────────────────────────────────────────────────
        const Text("Enfant", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() {
          if (childrenCtrl.children.isEmpty) {
            return const Text(
              "Aucun enfant ajouté. Veuillez d'abord ajouter un enfant.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            );
          }

          return DropdownButtonFormField<String>(
            value: regCtrl.selectedChild.value?.id,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text("Sélectionnez un enfant"),
            items: childrenCtrl.children
                .map((child) => DropdownMenuItem(
              value: child.id,
              child: Text(child.fullName),
            ))
                .toList(),
            onChanged: (childId) {
              if (childId != null) {
                final child = childrenCtrl.children.firstWhere((c) => c.id == childId);
                regCtrl.selectedChild.value = child;
              }
            },
          );
        }),

        const SizedBox(height: 12),

        // 🚨 Alerte si enfant déjà inscrit
        Obx(() {
          final child = regCtrl.selectedChild.value;
          if (child != null && child.isAlreadyRegisteredThisYear) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Cet enfant est déjà inscrit pour l'année scolaire en cours.",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 20),

        // ─────────────────────────────────────────────────────
        // 2️⃣ SÉLECTION ÉTABLISSEMENT
        // ─────────────────────────────────────────────────────
        const Text("Établissement", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedSchoolName,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: const Text("Sélectionnez un établissement"),
          items: regCtrl.availableSchools
              .map((school) => DropdownMenuItem(
            value: school,
            child: Text(school),
          ))
              .toList(),
          onChanged: (school) {
            setState(() {
              selectedSchoolName = school;
              selectedLevel = null; // 🔄 Reset niveau quand on change d'école
              regCtrl.selectedFee.value = null;
              regCtrl.totalAmount.value = 0;
            });
          },
        ),

        const SizedBox(height: 20),

        // ─────────────────────────────────────────────────────
        // 3️⃣ SÉLECTION NIVEAU (conditionnel)
        // ─────────────────────────────────────────────────────
        const Text("Niveau", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // ✅ SOLUTION : Guard contre null
        if (selectedSchoolName == null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: const Text(
              "Veuillez d'abord sélectionner un établissement",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ] else ...[
          // ✅ Ici selectedSchoolName est garanti non-null
          DropdownButtonFormField<String>(
            value: selectedLevel,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text("Sélectionnez un niveau"),
            items: regCtrl.levelsForSchool(selectedSchoolName!) // ✅ Safe ici
                .map((level) => DropdownMenuItem(
              value: level,
              child: Text(level),
            ))
                .toList(),
            onChanged: (level) {
              setState(() {
                selectedLevel = level;
                if (level != null && selectedSchoolName != null) {
                  regCtrl.selectFee(selectedSchoolName!, level);
                }
              });
            },
          ),
        ],

        const SizedBox(height: 24),

        // ─────────────────────────────────────────────────────
        // 4️⃣ AFFICHAGE DU MONTANT
        // ─────────────────────────────────────────────────────
        Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: regCtrl.totalAmount.value > 0
                ? AppColors.primarySoft.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: regCtrl.totalAmount.value > 0
                  ? AppColors.primarySoft
                  : Colors.grey.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Frais d'inscription",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "${regCtrl.totalAmount.value} FCFA",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: regCtrl.totalAmount.value > 0
                      ? AppColors.primarySoft
                      : Colors.grey,
                ),
              ),
            ],
          ),
        )),

        const SizedBox(height: 30),
// ─────────────────────────────────────────────────────
// 5️⃣ BOUTON SUIVANT
// ─────────────────────────────────────────────────────
        Obx(() {
          // ✅ Calcul réactif de canProceed
          final child = regCtrl.selectedChild.value;
          final fee = regCtrl.selectedFee.value;

          final canProceed = child != null &&
              fee != null &&
              !child.isAlreadyRegisteredThisYear;

          return GradientButton(
            label: "Suivant",
            onTap: canProceed ? () => setState(() => step = 1) : null,
          );
        }),
      ],
    );
  }

  // ================== ÉTAPE 2 (SAFE) ==================
  Widget _buildSummarySafe({Key? key}) {
    final child = regCtrl.selectedChild.value;
    final fee = regCtrl.selectedFee.value;

    if (child == null || fee == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Veuillez compléter l'étape précédente.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      key: key,
      children: [
        _row("Enfant", child.fullName),
        _row("Établissement", fee.schoolName),
        _row("Niveau", fee.level),
        const Divider(height: 32),
        _row("TOTAL", "${fee.amount} FCFA", bold: true),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => step = 0),
                child: const Text("Modifier"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GradientButton(
                label: "Confirmer",
                onTap: () {
                  Get.toNamed(Routes.payment);
                },
              ),
            ),

          ],
        ),
      ],
    );
  }

  // ================== ÉTAPE 3 (SAFE) ==================
// Dans registration_start_page.dart, étape 3 (paiement)
  Widget _buildPaymentSafe({Key? key}) {

    if (regCtrl.selectedFee.value == null || regCtrl.selectedChild.value == null) {
      return const Text("...");
    }

    return Column(
      key: key,
      children: [
        const Text("Récapitulatif", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _row("Enfant", regCtrl.selectedChild.value!.fullName),
        _row("École", regCtrl.selectedFee.value!.schoolName),
        _row("Niveau", regCtrl.selectedFee.value!.level),
        _row("TOTAL", "${regCtrl.selectedFee.value!.amount} FCFA", bold: true),
        const SizedBox(height: 25),
        GradientButton(
          label: "Confirmer l'inscription",
          onTap: () {
            final record = regCtrl.confirmRegistration();
            Get.offNamed(Routes.feesSuccess, arguments: {
              'childName': record.childName,
              'schoolName': record.schoolName,
              'amount': record.amount,
              'service': 'inscription',
              'date': record.date,
            });
          },
        ),
      ],
    );
  }
  Widget _buildMethodTile(String name, String asset, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppColors.primarySoft : Colors.grey.shade200, width: 2),
        color: isSelected ? AppColors.primarySoft.withOpacity(0.05) : Colors.white,
      ),
      child: Row(
        children: [
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.primarySoft),
          const SizedBox(width: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _row(String k, String v, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontSize: 15)),
          Text(
            v,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: bold ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }


  void _processFinalAction() async {
    // 1️⃣ Chargement visuel
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.primarySoft),
      ),
      barrierDismissible: false,
    );

    // 2️⃣ Simulation réseau / paiement
    await Future.delayed(const Duration(seconds: 2));
    Get.back(); // ferme le loader

    // 3️⃣ Enregistrement métier (inscription)
    final record = regCtrl.confirmRegistration();

    // 4️⃣ Historique
    final historyCtrl = Get.find<PaymentHistoryController>();
    historyCtrl.addHistory(
      PaymentHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        childName: record.childName,
        service: PaymentServiceType.inscription,
        amount: record.amount,
        date: DateTime.now(),
        method: "Airtel Money",
        success: true,
      ),
    );

    // 5️⃣ Redirection
    Get.offNamed(Routes.childPaymentsHistory);

    // 6️⃣ Feedback utilisateur
    Get.snackbar(
      "✅ Inscription réussie",
      "Reçu généré pour ${record.childName}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}