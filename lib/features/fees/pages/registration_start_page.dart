import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../children/controllers/children_controller.dart';
import '../../history/controllers/payment_history_controller.dart';
import '../../history/models/payment_history_model.dart';
import '../../schools/controllers/schools_controller.dart';
import '../../schools/models/level_model.dart';
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
  final schoolsCtrl = Get.find<SchoolsController>();

  String? selectedLevel;
  String? selectedSchoolName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildPinterestStepper(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStepContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _getStepWidget(),
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

  // ─────────────────────────────────────────────────────────────
  // STEPPER
  // ─────────────────────────────────────────────────────────────
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent || isPast
                        ? AppColors.primarySoft
                        : Colors.grey.shade200,
                    boxShadow: isCurrent
                        ? [
                      BoxShadow(
                        color: AppColors.primarySoft.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Center(
                    child: isPast
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: isCurrent ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                    isCurrent ? FontWeight.w800 : FontWeight.w500,
                    color:
                    isCurrent ? AppColors.textPrimary : Colors.grey,
                  ),
                ),
              ],
            ),
            if (index < labels.length - 1)
              Container(
                width: 50,
                height: 2,
                margin: const EdgeInsets.only(bottom: 20),
                color: isPast ? AppColors.primarySoft : Colors.grey.shade200,
              ),
          ],
        );
      }),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ÉTAPE 1 — SÉLECTION
  // ─────────────────────────────────────────────────────────────
  Widget _buildSelection({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── 1️⃣ ENFANT ──────────────────────────────────────────
        const Text("Enfant", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Obx(() {
          if (childrenCtrl.children.isEmpty) {
            return const Text(
              "Aucun enfant ajouté. Veuillez d'abord ajouter un enfant.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            );
          }

          return DropdownButtonFormField(
            initialValue: regCtrl.selectedChild.value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text("Sélectionnez un enfant"),
            items: childrenCtrl.children.map((child) {
              return DropdownMenuItem(
                value: child,
                child: Text(child.fullName),
              );
            }).toList(),
            onChanged: (child) {
              regCtrl.selectedChild.value = child;
            },
          );
        }),

        const SizedBox(height: 12),

        // 🚨 Alerte enfant déjà inscrit
        Obx(() {
          final child = regCtrl.selectedChild.value;
          if (child != null && child.isAlreadyRegisteredThisYear) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Cet enfant est déjà inscrit pour l'année scolaire en cours.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        const SizedBox(height: 20),

        // ── 2️⃣ ÉTABLISSEMENT ───────────────────────────────────
        const Text("Établissement",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Obx(() => DropdownButtonFormField(
          value: schoolsCtrl.selectedSchool.value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          hint: const Text("Sélectionnez un établissement"),
          items: schoolsCtrl.schools.map((school) {
            return DropdownMenuItem(
              value: school,
              child: Text(school.name),
            );
          }).toList(),
          onChanged: (school) {
            if (school != null) {
              schoolsCtrl.selectSchool(school);
            }
          },
        )),

        const SizedBox(height: 20),

        // ── 3️⃣ CLASSE / NIVEAU (conditionnel) ──────────────────
        const Text("Classe", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Obx(() {
          final school = schoolsCtrl.selectedSchool.value;

          if (school == null) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: const Text(
                "Veuillez d'abord sélectionner un établissement",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            );
          }

          return DropdownButtonFormField<LevelModel>(
            value: schoolsCtrl.selectedLevel.value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text("Sélectionnez un niveau"),
            items: schoolsCtrl.levels.map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level.name),
              );
            }).toList(),
            onChanged: (level) {
              if (level != null) schoolsCtrl.selectLevel(level);
            },
          );
        }),

        const SizedBox(height: 24),

        // ── 4️⃣ CARTE FRAIS D'INSCRIPTION ───────────────────────
        // 🔧 UI restaurée — logique à brancher (selectedFee / totalAmount)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Frais d'inscription",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                "— FCFA",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // ── 5️⃣ BOUTON SUIVANT ───────────────────────────────────
        Obx(() => GradientButton(
          label: "Suivant",
          onTap: regCtrl.canProceed
              ? () => setState(() => step = 1)
              : null,
        )),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ÉTAPE 2 — RÉSUMÉ
  // ─────────────────────────────────────────────────────────────
  Widget _buildSummarySafe({Key? key}) {
    final child = regCtrl.selectedChild.value;
    final school = schoolsCtrl.selectedSchool.value;
    final classe = schoolsCtrl.selectedLevel.value;

    if (child == null || school == null || classe == null) {
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
        _row("Établissement", school.name),
        _row("Classe", classe.name),
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
                onTap: () => setState(() => step = 2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ÉTAPE 3 — PAIEMENT
  // ─────────────────────────────────────────────────────────────
  Widget _buildPaymentSafe({Key? key}) {
    return Column(
      key: key,
      children: [
        const SizedBox(height: 30),
        Obx(() => GradientButton(
          label: regCtrl.isLoading.value
              ? "Inscription..."
              : "Confirmer l'inscription",
          onTap: regCtrl.isLoading.value
              ? null
              : () async {
            await regCtrl.confirmRegistration();

            Get.snackbar(
              "Succès",
              "Inscription enregistrée",
              snackPosition: SnackPosition.BOTTOM,
            );

            Get.offNamed(Routes.home);
          },
        )),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WIDGETS UTILITAIRES
  // ─────────────────────────────────────────────────────────────
  Widget _buildMethodTile(String name, String asset, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primarySoft : Colors.grey.shade200,
          width: 2,
        ),
        color: isSelected
            ? AppColors.primarySoft.withValues(alpha: 0.05)
            : Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: AppColors.primarySoft,
          ),
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
}