import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../models/school_model.dart';

class SchoolsService {
  Future<List<SchoolModel>> fetchSchool() async {
    final response = await ApiClient.get("/ecoles");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded is List ? decoded : (decoded['data'] ?? decoded['ecoles'] ?? []);
      final List list = data;
      return list.map((e) => SchoolModel.fromJson(e)).toList();
    }

    throw Exception("Erreur chargement etablissements (${response.statusCode})");
  }

}