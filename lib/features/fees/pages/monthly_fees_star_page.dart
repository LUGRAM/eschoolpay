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

            /// CONTENU
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() {

                  final children = childrenCtrl.children;

                  if (children.isEmpty) {
                    return const Center(
                      child: Text(
                        "Aucun enfant trouvé.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final eligibleChildren = children
                      .where((c) =>
                  c.schoolId != null && c.grade != null)
                      .toList();

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// ENFANT
                        const Text(
                          "Enfant",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<ChildModel>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: feesCtrl.selectedChild.value,
                          items: eligibleChildren
                              .map((child) => DropdownMenuItem(
                            value: child,
                            child: Text(
                              child.displayGrade.isNotEmpty
                                  ? "${child.fullName} (${child.displayGrade})"
                                  : child.fullName,
                            ),
                          ))
                              .toList(),
                          onChanged: (child) {
                            if (child != null) {
                              feesCtrl.selectChild(child);
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        /// TRANCHES
                        const Text(
                          "Tranche",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 12),

                        Obx(() {
                          final options =
                              feesCtrl.availableMonthlyOptions;

                          if (feesCtrl.selectedChild.value == null) {
                            return const Text(
                              "Veuillez sélectionner un enfant.",
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
                                margin:
                                const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primarySoft
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  leading: Radio(
                                    value: opt,
                                    groupValue: feesCtrl
                                        .selectedMonthlyOption.value,
                                    onChanged: (_) {
                                      feesCtrl.selectedMonthlyOption
                                          .value = opt;
                                    },
                                  ),
                                  title: Text("${opt.months} mois"),
                                  subtitle: opt.discountPercent != null
                                      ? Text(
                                      "-${opt.discountPercent}%")
                                      : opt.discountFixed != null
                                      ? Text(
                                      "-${opt.discountFixed} FCFA")
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
                  );
                }),
              ),
            ),

            /// FOOTER
            Padding(
              padding:
              const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() {
                final opt = feesCtrl.selectedMonthlyOption.value;
                final amount = opt?.finalAmount ?? 0;

                feesCtrl.currentService.value =
                    ServiceType.mensualite;

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