// features/home/widgets/home_content.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../history/controllers/payment_history_controller.dart';
import '../../history/models/payment_history_model.dart';
import 'build_year_selector.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildYearSelector(),
              const SizedBox(height: 25),
              _buildQuickActions(),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Derniers paiements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigue vers l'onglet Historique (index 0)
                      // On remonte au parent via callback si besoin
                    },
                    child: const Text(
                      "Voir tout",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildPaymentList(),
          ),
        ),
      ],
    );
  }
}

Widget _buildQuickActions() {
  return Row(
    children: [
      _actionCard(
        "Mes enfants",
        Icons.child_care,
        const Color(0xFFE3F2FD),
            () => Get.toNamed(Routes.childrenList),
      ),
      const SizedBox(width: 15),
      _actionCard(
        "Nos services",
        Icons.business_center,
        const Color(0xFFF3E5F5),
            () => Get.toNamed(Routes.servicesMenu),
      ),
    ],
  );
}

Widget _actionCard(String title, IconData icon, Color bg, VoidCallback onTap) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: bg,
              radius: 25,
              child: Icon(icon, color: const Color(0xFF063D66)),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPaymentList() {
  const primaryBlue = Color(0xFF063D66);
  final ctrl = Get.find<PaymentHistoryController>();

  return Obx(() {
    final recent = ctrl.recentPayments;

    if (recent.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "Aucun paiement récent.",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: recent
          .map((h) => GestureDetector(
        onTap: () => Get.toNamed(Routes.paymentDetail, arguments: h),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(18),
            border:
            Border.all(color: Colors.black.withValues(alpha: 0.04)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  ctrl.serviceIcon(h.service),
                  color: primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.serviceLabel(h.service),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _formatDate(h.date),
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatAmount(h.amount),
                    style: const TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: ctrl.statusBgColor(h.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ctrl.statusLabel(h.status),
                      style: TextStyle(
                        color: ctrl.statusColor(h.status),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ))
          .toList(),
    );
  });
}

String _formatDate(DateTime d) =>
    "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

String _formatAmount(int amount) {
  final s = amount.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write(' ');
    result.write(s[i]);
  }
  return '${result.toString()} FCFA';
}