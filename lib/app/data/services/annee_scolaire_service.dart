import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/annee_scolaire.dart';

class AnneeScolaireService {

  final String baseUrl;

  AnneeScolaireService({required this.baseUrl});

  Future<List<AnneeScolaire>> fetchSchoolYears(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/school-years"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((e) => AnneeScolaire.fromJson(e))
          .toList();
    } else {
      throw Exception("Erreur chargement années scolaires");
    }
  }
}