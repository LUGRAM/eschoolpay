import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../children/controllers/children_controller.dart';
import '../../children/models/child_model.dart';
import '../controllers/fees_controller.dart';
import '../models/cantine_option_model.dart';

class CantineStartPage extends StatelessWidget {
  const CantineStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feesCtrl = Get.find<FeesController>();
    final childrenCtrl = Get.find<ChildrenController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Cantine scolaire")),
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────────────────
            // CONTENU SCROLLABLE
            // ─────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1️⃣ ENFANT
                    const Text(
                      "Enfant",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Obx(() {
                      final eligibleChildren = childrenCtrl.children
                          .where((c) => c.schoolId != null)
                          .toList();

                      if (eligibleChildren.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.info_outline, color: Colors.orange),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Aucun enfant inscrit. Veuillez d'abord inscrire un enfant dans un établissement.",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return DropdownButtonFormField<ChildModel>(
                        value: feesCtrl.selectedChild.value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        hint: const Text("Sélectionnez un enfant"),
                        items: eligibleChildren
                            .map(
                              (c) => DropdownMenuItem(
                            value: c,
                            child:
                            Text("${c.fullName} (${c.displaySchool})"),
                          ),
                        )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            feesCtrl.selectChild(val);
                          }
                        },
                      );
                    }),

                    const SizedBox(height: 24),

                    // 2️⃣ FORFAITS CANTINE
                    const Text(
                      "Forfait cantine",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    Obx(() {
                      final options = feesCtrl.availableCantineOptions;

                      if (feesCtrl.selectedChild.value == null) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            "Veuillez d'abord sélectionner un enfant",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      if (options.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.restaurant, color: Colors.red),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Aucun forfait cantine disponible pour cet établissement.",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: options.map((CantineOption opt) {
                          final selected =
                              feesCtrl.selectedCantineOption.value == opt;

                          return GestureDetector(
                            onTap: () =>
                            feesCtrl.selectedCantineOption.value = opt,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: selected
                                    ? AppColors.primarySoft.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.05),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primarySoft
                                      : Colors.grey.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Radio<CantineOption>(
                                  value: opt,
                                  groupValue:
                                  feesCtrl.selectedCantineOption.value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      feesCtrl.selectedCantineOption.value =
                                          value;
                                    }
                                  },
                                  activeColor: AppColors.primarySoft,
                                ),
                                title: Text(
                                  opt.label,
                                  style: TextStyle(
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: opt.note != null
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.only(top: 4),
                                  child: Text(
                                    opt.note!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                    : null,
                                trailing: Text(
                                  "${opt.amount} FCFA",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: selected
                                        ? AppColors.primarySoft
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ─────────────────────────────────────────────
            // FOOTER FIXE
            // ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Obx(() {
                    final amount =
                        feesCtrl.selectedCantineOption.value?.amount ?? 0;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: amount > 0
                            ? AppColors.primarySoft.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: amount > 0
                              ? AppColors.primarySoft
                              : Colors.grey.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "$amount FCFA",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: amount > 0
                                  ? AppColors.primarySoft
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(() {
                    final canProceed =
                        feesCtrl.selectedCantineOption.value != null;

                    return GradientButton(
                      label: "Continuer",
                      onTap: canProceed
                          ? () {
                        feesCtrl.currentService.value =
                            ServiceType.cantine;
                        Get.toNamed(Routes.payment);
                      }
                          : null,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
