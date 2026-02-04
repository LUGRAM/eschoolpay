import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/router/routes.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../../app/widgets/page_scaffold.dart';

class FeesSuccessPage extends StatelessWidget {
  const FeesSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text("Erreur : aucune donnée")),
      );
    }

    final status = args['status'] ?? 'ERROR';
    final isSuccess = status == 'SUCCESS';
    final childName = args['childName'] ?? 'N/A';
    final feeLabel = args['feeLabel'] ?? 'Service';
    final amount = args['amount'] ?? 0;
    final method = args['method'] ?? 'Mobile Money';
    final date = args['date'] as DateTime? ?? DateTime.now();

    return PageScaffold(
      title: "Paiement",
      showHelp: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ICÔNE
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            size: 86,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 16),

          // TITRE
          Text(
            isSuccess ? "Paiement réussi !" : "Paiement échoué",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),

          // DÉTAILS
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildRow("Enfant", childName),
                _buildRow("Service", feeLabel),
                _buildRow("Montant", "$amount FCFA", bold: true),
                _buildRow("Mode", method),
                _buildRow(
                  "Date",
                  DateFormat('dd/MM/yyyy à HH:mm').format(date),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // BOUTON RETOUR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GradientButton(
              label: "Retour à l'accueil",
              onTap: () => Get.offAllNamed(Routes.home),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}