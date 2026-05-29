import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/annee_scolaire_controller.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../children/controllers/children_controller.dart';
import '../../children/models/child_model.dart';
import '../controllers/fees_controller.dart';
import '../data/mock_informatique_options.dart';

class InformatiqueStartPage extends StatelessWidget {
  const InformatiqueStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feesCtrl = Get.find<FeesController>();
    final childrenCtrl = Get.find<ChildrenController>();
    final anneeCtrl = Get.find<AnneeScolaireController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Cours d'Informatique")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final children = childrenCtrl.childrenInscrit;
                  final selectedYear = anneeCtrl.selectedYear.value;

                  if (selectedYear == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final eligibleChildren = children
                      .where((c) => c.schoolId != null)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1️⃣ ENFANT
                      const Text(
                        "Enfant",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),

                      if (eligibleChildren.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Row(
                            children: [
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
                        )
                      else
                        DropdownButtonFormField<ChildModel>(
                          initialValue: feesCtrl.selectedChild.value,
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
                              child: Text(
                                c.displaySchool.isNotEmpty && c.displaySchool != "Non renseignée"
                                    ? "${c.fullName} (${c.displaySchool})"
                                    : c.fullName,
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: (val) {
                            if (val?.id != null) {
                              feesCtrl.selectChild(
                                val!,
                                selectedYear.id.toString(),
                                "INFORMATIQUE",
                              );
                            }
                          },
                        ),

                      const SizedBox(height: 24),

                      // 2️⃣ FORMATIONS
                      const Text(
                        "Formation informatique",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      Builder(builder: (context) {
                        if (feesCtrl.selectedChild.value == null) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
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

                        if (feesCtrl.isLoadingFrais.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        // API-first
                        final options = feesCtrl.fraisInformatique;

                        if (options.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.computer_rounded, color: Colors.red),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Aucune formation disponible pour cet établissement.",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: options.map((opt) {
                            final isSelected =
                                feesCtrl.selectedInformatiqueOption.value?.id == opt.id;

                            return GestureDetector(
                              onTap: () {
                                feesCtrl.selectedInformatiqueOption.value = opt;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isSelected
                                      ? AppColors.primarySoft.withValues(alpha: 0.1)
                                      : Colors.grey.withValues(alpha: 0.05),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primarySoft
                                        : Colors.grey.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: Radio(
                                    value: opt,
                                    groupValue: feesCtrl.selectedInformatiqueOption.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        feesCtrl.selectedInformatiqueOption.value = value;
                                      }
                                    },
                                    activeColor: AppColors.primarySoft,
                                  ),
                                  title: Text(
                                    opt.libelle,
                                    style: TextStyle(
                                      fontWeight:
                                          isSelected ? FontWeight.bold : FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${opt.montant.toInt()} FCFA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isSelected
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
                  );
                }),
              ),
            ),


            // FOOTER FIXE
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Obx(() {
                    final amount = feesCtrl
                            .selectedInformatiqueOption.value?.montant ??
                        0.0;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: amount > 0
                            ? AppColors.primarySoft
                                .withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: amount > 0
                              ? AppColors.primarySoft
                              : Colors.grey.withValues(alpha: 0.2),
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
                            "${amount.toInt()} FCFA",
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
                    final canProceed = feesCtrl
                            .selectedInformatiqueOption.value !=
                        null;

                    return GradientButton(
                      label: "Continuer",
                      onTap: canProceed
                          ? () {
                              feesCtrl.currentService.value =
                                  ServiceType.informatique;
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
