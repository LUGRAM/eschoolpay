import 'dart:convert';
import '../../../core/network/api_client.dart';

class InscriptionService {
  Future<void> createInscription({
    required int eleveId,
    required int levelId,
    required int anneeId,
    required double frais,
  }) async {

    final response = await ApiClient.post(
      "/inscriptions",
      {
        "eleve_id": eleveId,
        "level_id": levelId,
        "annee_scolaire_id": anneeId,
        "date_inscription": DateTime.now().toIso8601String(),
        "frais_inscription": frais,
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Erreur inscription");
    }
  }
}