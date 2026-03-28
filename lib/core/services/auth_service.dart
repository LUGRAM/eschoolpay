import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../network/api_client.dart';

class AuthService {
  final GetStorage _box = GetStorage();

  // Sauvegarder token
  void saveToken(String token) {
    _box.write("token", token);
  }

  // Lire token
  String? get token => _box.read("token");

  // Supprimer token
  void logout() {
    _box.remove("token");
  }

  // ========= REGISTER =========
  Future<Map<String, dynamic>?> register({
    required String phone,
  }) async {
    final response = await ApiClient.post(
      "/register",
      {
        "phone": phone
      },
    );

    final decoded = jsonDecode(response.body);

    print("========= Retour Register =========");
    print(decoded);

    if (decoded["token"] != null) {
      saveToken(decoded["token"]);
    }

    return decoded;
  }

  // ========= LOGIN =========
  Future<Map<String, dynamic>> login({
    required String phone
  }) async {
    final response = await ApiClient.post(
      "/login",
      {
        "phone": phone
      },
    );

    final decoded = jsonDecode(response.body);

    print("========= Retour Login =========");
    print(decoded);

    if (decoded["token"] != null) {
      saveToken(decoded["token"]);
    }

    return decoded;
  }
}
