import 'dart:convert';

import '../../../core/network/api_client.dart';
import '../models/classe_model.dart';

class ClasseService {
  Future<List<ClasseModel>> fetchClasse() async {
    final response = await ApiClient.get("/classes");

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => ClasseModel.fromJson(e)).toList();
    }

    throw Exception("Erreur chargement classes (${response.statusCode})");

  }
}