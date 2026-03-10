import 'dart:convert';
import '../../../core/network/api_client.dart';

class InscriptionService {
  Future<void> createInscription({
    required int ecoleId,
    required int eleveId,
    required int levelId,
    required int anneeId,
    required double frais,
  }) async {

    print({
      "ecole_id": ecoleId,
      "eleve_id": eleveId,
      "niveau_id": levelId,
      "annee_scolaire_id": anneeId,
      "date_inscription": DateTime.now().toIso8601String(),
      "frais_inscription": frais,
    });
    final response = await ApiClient.post(
      "/inscriptions",
      {
        "ecole_id": ecoleId,
        "eleve_id": eleveId,
        "niveau_id": levelId,
        "annee_scolaire_id": anneeId,
        "date_inscription": DateTime.now().toIso8601String(),
        "frais_inscription": frais,
      },
    );

    print(response.body);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Erreur inscription");
    }
  }
}