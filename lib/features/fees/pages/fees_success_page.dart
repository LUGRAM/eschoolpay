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

    final String status = args['status'] ?? 'ERROR';
    final bool isSuccess = status == 'SUCCESS';
    final bool isPending = status == 'PENDING';
    final bool isError = !isSuccess && !isPending;

    final childName = args['childName'] ?? 'N/A';
    final feeLabel = args['feeLabel'] ?? 'Service';
    final amount = args['amount'] ?? 0;
    final method = args['method'] ?? 'Mobile Money';
    final date = args['date'] as DateTime? ?? DateTime.now();
    final errorMessage =
        args['errorMessage'] ?? "Impossible de traiter votre paiement.";

    Color primaryColor = Colors.green;
    IconData statusIcon = Icons.check_circle_rounded;
    String titleText = "Paiement réussi !";
    String subtitleText = "Votre transaction a été confirmée.";

    if (isPending) {
      primaryColor = Colors.orange;
      statusIcon = Icons.schedule_rounded;
      titleText = "Demande enregistrée";
      subtitleText = "En attente de règlement au guichet.";
    } else if (isError) {
      primaryColor = Colors.red;
      statusIcon = Icons.cancel_rounded;
      titleText = "Paiement échoué";
      subtitleText = "Votre transaction n'a pas pu être finalisée.";
    }

    return PageScaffold(
      title: isPending ? "Confirmation" : "Paiement",
      showHelp: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            statusIcon,
            size: 86,
            color: primaryColor,
          ),

          const SizedBox(height: 16),

          Text(
            titleText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitleText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildRow("Élève", childName),
                _buildRow("Type", feeLabel),
                _buildRow("Montant", "$amount FCFA",
                    bold: true, color: primaryColor),
                _buildRow("Mode", method),
                _buildRow(
                  "Date",
                  DateFormat('dd/MM/yyyy à HH:mm').format(date),
                ),

                if (isPending) ...[
                  const Divider(height: 30),
                  const Text(
                    "Note : Votre inscription sera activée dès réception des fonds par l'administration.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.orange,
                    ),
                  ),
                ],

                if (isError) ...[
                  const Divider(height: 30),

                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Vérifiez votre connexion ou votre solde Mobile Money puis réessayez.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                if (isError)
                  GradientButton(
                    label: "Réessayer",
                    onTap: () {
                      Get.back();
                    },
                  ),

                if (isError) const SizedBox(height: 12),

                GradientButton(
                  label: "Retour à l'accueil",
                  onTap: () => Get.offAllNamed(Routes.home),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {bool bold = false, Color? color}) {
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
              color: color,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}