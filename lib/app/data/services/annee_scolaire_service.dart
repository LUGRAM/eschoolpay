import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../models/annee_scolaire.dart';

class AnneeScolaireService {
  Future<List<AnneeScolaire>> fetchSchoolYears() async {
    final response = await ApiClient.get("/annees");

    // des Logs
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List list = decoded;

      return list.map((e) => AnneeScolaire.fromJson(e)).toList();
    }

    throw Exception("Erreur chargement années scolaires (${response.statusCode})");
  }
}