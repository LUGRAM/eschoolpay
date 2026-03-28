import 'dart:convert';
import '../../../core/network/api_client.dart';

class InscriptionService {
  Future<Map<String, dynamic>> createInscription({
    required int eleveId,
    required int levelId,
    required int anneeId,
    required int ecoleId,
    required double frais,
  }) async {
    final body = {
      "eleve_id": eleveId,
      "niveau_id": levelId,
      "annee_scolaire_id": anneeId,
      "ecole_id": ecoleId,
      "date_inscription": DateTime.now().toIso8601String(),
      "frais_inscription": frais,
    };
    print(body);

    final response = await ApiClient.post("/inscriptions", body);

    print(response.body);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Erreur inscription (${response.statusCode})");
    }

    return jsonDecode(response.body);
  }
}