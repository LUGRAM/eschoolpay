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

    final response = await ApiClient.post("/inscriptions", body);

    final data = jsonDecode(response.body);

    print(data);

    // 🔥 Gestion propre des erreurs métier
    if (response.statusCode != 201 && response.statusCode != 200) {

      // Si message venant du backend
      if (data is Map && data.containsKey('message')) {
        throw Exception(data['message']); // 👈 message clair
      }

      throw Exception("Erreur inscription (${response.statusCode})");
    }

    return data;
  }
}