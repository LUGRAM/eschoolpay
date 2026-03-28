/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../children/models/child_model.dart';
import '../controllers/fees_controller.dart';

class ChildPaymentsHistoryPage extends StatelessWidget {
  const ChildPaymentsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feesCtrl = Get.find<FeesController>();

    final args = Get.arguments;
    if (args == null || args is! ChildModel) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text("Enfant invalide.")),
      );
    }

    final child = args;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Historique • ${child.fullName}"),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Obx(() {
        final list = feesCtrl.paymentsForChild(child.id);

        if (list.isEmpty) {
          return const Center(
            child: Text(
              "Aucun paiement pour cet enfant.",
              style: TextStyle(color: AppColors.textMuted),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final p = list[i];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.feeLabel,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${p.amount} FCFA • ${p.method}",
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${p.createdAt.day.toString().padLeft(2, '0')}/"
                        "${p.createdAt.month.toString().padLeft(2, '0')}/"
                        "${p.createdAt.year} • ${p.status}",
                    style: TextStyle(
                      color: p.status == "SUCCESS"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
*/