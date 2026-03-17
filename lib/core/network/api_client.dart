import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../features/fees/models/frais_scolaire_model.dart';

class ApiClient {
  static const String baseUrl =
      "https://eschool.itmaster-africa.com/api";

  static final GetStorage _box = GetStorage();

  // ================= TOKEN CENTRALISÉ =================
  static String? get _token {
    final token = _box.read("auth_token") ?? _box.read("token");
    return token;
  }

  // ================= HEADERS JSON =================
  static Map<String, String> get jsonHeaders {
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (_token != null) {
      headers["Authorization"] = "Bearer $_token";
    }

    return headers;
  }

  // ================= HEADERS MULTIPART =================
  static Map<String, String> get multipartHeaders {
    final headers = {
      "Accept": "application/json",
    };

    if (_token != null) {
      headers["Authorization"] = "Bearer $_token";
    }

    return headers;
  }

  // ================= GET =================
  static Future<http.Response> take(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) async {

    final uri = Uri.parse("$baseUrl$endpoint").replace(
      queryParameters: queryParameters?.map(
            (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await http.get(
      uri,
      headers: jsonHeaders,
    );

    return response;
  }

  static Future<List<FraisScolaireModel>> getFraisScolaire({
    required String childId,
    required String yearId,
    required String type
  }) async {

    final uri = Uri.parse("$baseUrl/frais-scolaires").replace(
      queryParameters: {
        "child_id": childId,
        "annee_scolaire_id": yearId,
        "type": type
      },
    );

    final response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        if (_token != null) "Authorization": "Bearer $_token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur chargement frais scolaires");
    }

    final Map<String, dynamic> body = jsonDecode(response.body);

    final List data = body["data"]; // la clé importante

    return data
        .map((e) => FraisScolaireModel.fromJson(e))
        .toList();
  }

  static Future<http.Response> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
    );

    return response;
  }

  // ================= POST =================
  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
      body: jsonEncode(data),
    );

    return response;
  }

  // ================= PUT =================
  static Future<http.Response> put(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
      body: jsonEncode(data),
    );

    return response;
  }

  // ================= DELETE =================
  static Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: jsonHeaders,
    );

    return response;
  }

  // ================= MULTIPART =================
  static Future<http.StreamedResponse> multipart({
    required String endpoint,
    String method = 'POST',
    Map<String, String>? fields,
    File? file,
    String fileField = 'photo',
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest(method, uri);

    request.headers.addAll(multipartHeaders);

    if (fields != null && fields.isNotEmpty) {
      request.fields.addAll(fields);
    }

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          file.path,
        ),
      );
    }

    return request.send();
  }
}