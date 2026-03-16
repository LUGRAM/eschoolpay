import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/network/api_client.dart';

class PaymentApi {

  final GetStorage _box = GetStorage();

  String? get token => _box.read("token");

  Future<Map<String, dynamic>> pay({
    required String commandeId,
    required String method,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiClient.baseUrl}/paiement"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "commande_messe_id": commandeId,
        "payment_method": method,
        "payment_phone": phone,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> check(String reference) async {
    final response = await http.post(
      Uri.parse("${ApiClient.baseUrl}/check-mobile-payment"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "reference": reference,
      }),
    );

    return jsonDecode(response.body);
  }
}
