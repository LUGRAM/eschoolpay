/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/registration_controller.dart';

class PaymentRegistrationPage extends StatefulWidget {
  const PaymentRegistrationPage({super.key});

  @override
  State<PaymentRegistrationPage> createState() =>
      _PaymentRegistrationPageState();
}

class _PaymentRegistrationPageState extends State<PaymentRegistrationPage> {
  final phoneCtrl = TextEditingController();
  String method = 'Airtel Money';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final regCtrl = Get.find<RegistrationController>();
    final fee = regCtrl.selectedFee.value;

    if (fee == null) {
      return const Scaffold(
        body: Center(child: Text("Erreur : aucune donnée")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paiement inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _amountBox(fee.amount),
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
                await Future.delayed(const Duration(seconds: 2));
                final record = regCtrl.confirmRegistration();
                setState(() => loading = false);

                Get.offNamed(Routes.feesSuccess, arguments: {
                  'childName': record.childName,
                  'amount': record.amount,
                  'service': 'Inscription',
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