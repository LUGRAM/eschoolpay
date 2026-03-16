import 'dart:convert';
import 'package:eschoolpay/core/network/api_client.dart';
import 'package:http/http.dart' as http;

class PaymentService {

  Future<Map<String, dynamic>> payerFrais({
    required int eleveId,
    required int anneeId,
    required int fraisId,
    required double montant,
    required String methode,
    required String telephone,
  }) async {

    final response = await ApiClient.post(
      "/paiement-frais",
      {
        "eleve_id": eleveId,
        "annee_scolaire_id": anneeId,
        "frais_scolaire_id": fraisId,
        "montant": montant,
        "date": DateTime.now().toIso8601String(),
        "methode": methode,
        "telephone": telephone
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> check(String reference) async {
    print("================Statut=================");
    print(reference);
    final response = await ApiClient.post(
      "/check-mobile-payment",
      {
        "reference": reference,
      },
    );

    print(response.body);

    return jsonDecode(response.body);
  }
}