/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/fees_controller.dart';

class PaymentFeesPage extends StatefulWidget {
  const PaymentFeesPage({super.key});

  @override
  State<PaymentFeesPage> createState() => _PaymentFeesPageState();
}

class _PaymentFeesPageState extends State<PaymentFeesPage> {
  final phoneCtrl = TextEditingController();
  String method = 'Airtel Money';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final feesCtrl = Get.find<FeesController>();

    if (feesCtrl.selected.value == null) {
      return const Scaffold(
        body: Center(child: Text("Erreur : aucune donnée")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paiement")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _amountBox(feesCtrl.totalAmount),
            const SizedBox(height: 24),
            _methodTile("Airtel Money"),
            _methodTile("Moov Money"),
            _methodTile("Espèce"),
            const SizedBox(height: 24),
            AppTextField(
              hint: "Numéro de téléphone",
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: loading ? null : () async {
                setState(() => loading = true);
                final record = await feesCtrl.payNow(method: method);
                Get.offNamed(Routes.feesSuccess, arguments: {
                  'status': record.status,
                  'childName': record.childName,
                  'feeLabel': record.feeLabel,
                  'amount': record.amount,
                  'method': record.method,
                  'date': record.createdAt,
                });
              },
              child: const Text("Payer"),
            )
          ],
        ),
      ),
    );
  }

  Widget _methodTile(String name) => ListTile(
    title: Text(name),
    leading: Radio(
      value: name,
      groupValue: method,
      onChanged: (_) => setState(() => method = name),
    ),
  );

  Widget _amountBox(int amount) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      "$amount FCFA",
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    ),
  );
}
*/