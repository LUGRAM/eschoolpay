/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../../app/widgets/page_scaffold.dart';
import '../controllers/fees_controller.dart';
import '../models/cantine_option_model.dart';
import '../models/monthly_fee_config_model.dart';

class FeesPreviewPage extends StatefulWidget {
  const FeesPreviewPage({super.key});

  @override
  State<FeesPreviewPage> createState() => _FeesPreviewPageState();
}

class _FeesPreviewPageState extends State<FeesPreviewPage> {
  bool loading = false;

  void _handlePayment(FeesController c) async {
    setState(() => loading = true);
    final result = await c.payNow(method: '');
    setState(() => loading = false);

    Get.offNamed(Routes.feesSuccess, arguments: result);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FeesController>();

    final child = c.selectedChild.value;
    final option = c.selected.value;
    final method = c.paymentMethod.value;

    if (child == null || option == null) {
      return const Scaffold(body: Center(child: Text("Erreur de données")));
    }

    final record = await feesCtrl.payNow(method: method);
    Get.offNamed(Routes.feesSuccess, arguments: {
      'status': record.status,
      'childName': record.childName,
      'feeLabel': record.feeLabel,
      'amount': record.amount,
      'method': record.method,
      'date': record.createdAt,
    });


    // ✅ Gestion des propriétés dynamiques selon le service
    String duration;
    int amount;

    if (c.currentService.value == ServiceType.mensualite) {
      final monthlyOpt = option as MonthlyFeeOption;
      duration = "${monthlyOpt.months} mois";
      amount = monthlyOpt.finalAmount;
    } else if (c.currentService.value == ServiceType.cantine) {
      final cantineOpt = option as CantineOption;
      duration = cantineOpt.label;
      amount = cantineOpt.amount;
    } else {
      duration = "N/A";
      amount = 0;
    }

    return PageScaffold(
      title: "Récapitulatif",
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                _RowLine(label: "Enfant", value: child.fullName),
                _RowLine(label: "École", value: child.displaySchool), // ✅ Corrigé
                _RowLine(label: "Classe", value: child.displayGrade), // ✅ Corrigé
                const Divider(height: 30),
                _RowLine(
                  label: "Service",
                  value: c.currentService.value.name.toUpperCase(),
                ),
                _RowLine(label: "Durée", value: duration), // ✅ Dynamique
                _RowLine(label: "Moyen", value: method),
                const SizedBox(height: 10),
                _RowLine(label: "TOTAL", value: "$amount FCFA", isTotal: true),
              ],
            ),
          ),

          const Spacer(),

          const Text(
            "En cliquant sur valider, une demande d'autorisation est envoyée à l'établissement.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text("Précédent"),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: GradientButton(
                  label: "Valider",
                  loading: loading,
                  onTap: () => _handlePayment(c),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _RowLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _RowLine({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? const Color(0xFF063D66) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
*/