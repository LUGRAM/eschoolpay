import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/page_scaffold.dart';
import '../controllers/children_controller.dart';

class ChildrenListPage extends StatelessWidget {
  const ChildrenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChildrenController>();

    return PageScaffold(
      title: "Mes enfants",
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (c.children.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucun enfant enregistré.\nAjoutez votre premier enfant.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                );
              }

              return ListView.separated(
                itemCount: c.children.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final child = c.children[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.primarySoft,
                          child: Icon(Icons.child_care_rounded, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(child.fullName,
                                  style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text("${child.schoolName} • ${child.grade}",
                                  style: const TextStyle(color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.toNamed(
                            Routes.childPaymentsHistory,
                            arguments: child,
                          ),
                          icon: const Icon(Icons.receipt_long_rounded),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primarySoft,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Get.toNamed(Routes.addChild),
              child: const Text("Ajouter un enfant",
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
