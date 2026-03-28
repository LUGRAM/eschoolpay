import 'dart:convert';
import 'dart:io';
import '../../../core/network/api_client.dart';
import '../models/child_model.dart';

class ChildrenService {
  Future<List<ChildModel>> fetchChildren() async {
    final response = await ApiClient.get("/eleves");

    print("======= ENFANTS =======");
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded is List ? decoded : decoded['data'];
      return list.map((e) => ChildModel.fromApi(e)).toList();
    }

    throw Exception("Erreur chargement enfants (${response.statusCode})");
  }

  Future<Map<String, dynamic>> createChild({
    required Map<String, String> fields,
    File? photo,
  }) async {
    print("======= CREATE ENFANT =======");
    print("FIELDS: $fields");

    final streamed = await ApiClient.multipart(
      endpoint: "/eleves",
      fileField: "photo",
      file: photo,
      fields: fields,
    );

    final body = await streamed.stream.bytesToString();
    print("STATUS CODE: ${streamed.statusCode}");
    print("BODY: $body");

    final decoded = body.isNotEmpty ? jsonDecode(body) : {};
    if (streamed.statusCode == 200 || streamed.statusCode == 201) return decoded;

    throw Exception("Erreur création élève (${streamed.statusCode}) => $body");
  }

}