import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_history_controller.dart';
import '../models/payment_history_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF063D66);
    final ctrl = Get.find<PaymentHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text("Historique",
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.histories.isEmpty) {
          return const Center(
            child: Text(
              "Aucune transaction effectuée.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: ctrl.histories.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final h = ctrl.histories[index];
            return _buildHistoryItem(h, primaryBlue, ctrl);
          },
        );
      }),
    );
  }

  Widget _buildHistoryItem(
      PaymentHistory h,
      Color primaryColor,
      PaymentHistoryController ctrl,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1F7),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_rounded, color: primaryColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ctrl.serviceLabel(h.service),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "${h.childName} • ${_formatDate(h.date)} • ${h.method}",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${h.amount} FCFA",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 16),
              ),
              Text(
                h.success ? "Succès" : "Échec",
                style: TextStyle(
                  color: h.success ? Colors.green : Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }
}
