import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../children/controllers/children_controller.dart';
import '../../children/models/child_model.dart';
import '../controllers/fees_controller.dart';

class MonthlyFeesStartPage extends StatelessWidget {
  const MonthlyFeesStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feesCtrl = Get.find<FeesController>();
    final childrenCtrl = Get.find<ChildrenController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Frais de scolarité")),
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Obx(() {
                      final eligibleChildren = childrenCtrl.children
                          .where((c) =>
                      c.schoolId != null && c.grade != null)
                          .toList();

                      if (eligibleChildren.isEmpty) {
                        return const Text(
                          "Aucun enfant éligible.",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      return DropdownButtonFormField<ChildModel>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        initialValue: feesCtrl.selectedChild.value,
                        items: eligibleChildren
                            .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                              "${c.fullName} (${c.displayGrade})"),
                        ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            feesCtrl.selectChild(val);
                          }
                        },
                      );
                    }),

                    const SizedBox(height: 24),

                    // 2️⃣ TRANCHES
                    const Text(
                      "Tranche",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Obx(() {
                      final options = feesCtrl.availableMonthlyOptions;

                      if (feesCtrl.selectedChild.value == null) {
                        return const Text(
                          "Veuillez d'abord sélectionner un enfant.",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      if (options.isEmpty) {
                        return const Text(
                          "Aucune tranche disponible.",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      return Column(
                        children: options.map((opt) {
                          final selected =
                              feesCtrl.selectedMonthlyOption.value == opt;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: selected
                                  ? AppColors.primarySoft.withValues(alpha:0.1)
                                  : Colors.grey.withValues(alpha:0.05),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primarySoft
                                    : Colors.grey.withValues(alpha:0.3),
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              leading: Radio(
                                value: opt,
                                groupValue:
                                feesCtrl.selectedMonthlyOption.value,
                                onChanged: (_) =>
                                feesCtrl.selectedMonthlyOption.value = opt,
                              ),
                              title: Text("${opt.months} mois"),
                              subtitle: opt.discountPercent != null
                                  ? Text("-${opt.discountPercent}%")
                                  : opt.discountFixed != null
                                  ? Text(
                                "-${opt.discountFixed} FCFA",
                              )
                                  : null,
                              trailing:
                              Text("${opt.finalAmount} FCFA"),
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
              child: Obx(() {
                final opt = feesCtrl.selectedMonthlyOption.value;
                final amount = opt?.finalAmount ?? 0;
                feesCtrl.currentService.value = ServiceType.mensualite;

                return GradientButton(
                  label: "Payer $amount FCFA",
                  onTap: opt != null
                      ? () => Get.toNamed(Routes.payment)
                      : null,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
