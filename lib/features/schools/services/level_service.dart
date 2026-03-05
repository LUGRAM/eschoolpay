import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../models/level_model.dart';

class LevelService {
  Future<List<LevelModel>> fetchLevels() async {
    final response = await ApiClient.get("/niveau");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => LevelModel.fromJson(e)).toList();
    }

    throw Exception("Erreur chargement niveaux");
  }
}