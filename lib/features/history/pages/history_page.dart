// features/history/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/router/routes.dart';
import '../controllers/payment_history_controller.dart';
import '../models/payment_history_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);
    final ctrl = Get.find<PaymentHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          "Historique",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.histories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }

        if (ctrl.histories.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text(
                  "Aucune transaction effectuée.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: primaryBlue,
          onRefresh: ctrl.fetchFromInscriptionsApi,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: ctrl.histories.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final h = ctrl.histories[index];
              return _HistoryItem(h: h, ctrl: ctrl);
            },
          ),
        );
      }),
    );
  }
}

// ─── ITEM CLIQUABLE ────────────────────────────────────────────
class _HistoryItem extends StatelessWidget {
  final PaymentHistory h;
  final PaymentHistoryController ctrl;

  const _HistoryItem({required this.h, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.paymentDetail, arguments: h),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icône service
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  ctrl.serviceIcon(h.service),
                  color: primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.serviceLabel(h.service),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${h.childName} • ${_formatDate(h.date)}",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Montant + statut
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatAmount(h.amount),
                    style: const TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ctrl.statusBgColor(h.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ctrl.statusLabel(h.status),
                      style: TextStyle(
                        color: ctrl.statusColor(h.status),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade300, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

  static String _formatAmount(int amount) {
    final s = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(' ');
      result.write(s[i]);
    }
    return '${result.toString()} FCFA';
  }
}