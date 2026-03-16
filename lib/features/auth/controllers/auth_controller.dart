import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/services/auth_service.dart';
import '../../../app/router/routes.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();
  final GetStorage _storage = GetStorage();
  int? get userId => _storage.read('user_id');

  final isLoading = false.obs;

  // ========= REGISTER =========
  // Téléphone only (le backend renvoie: { user, token } et éventuellement generated_password)
  Future<bool> register({required String phone}) async {
    isLoading.value = true;

    try {
      final decoded = await _service.register(phone: phone);

      final token = decoded?['token']; // backend
      final user = decoded?['user'];

      if (token != null) {
        _storage.write('auth_token', token);
        _storage.write('token', token);

        // Cache profil (les champs peuvent être null au début)
        if (user != null) {
          _storage.write('user_id', user['id']);
          _storage.write('user_name', user['name']);   // peut être null
          _storage.write('user_email', user['email']); // peut être null
          _storage.write('user_phone', user['phone']);
        }

        return true;
      }

      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ========= LOGIN =========
  // Téléphone + mot de passe (ou code) selon ton backend
  Future<bool> login({required String phone, required String password}) async {
    isLoading.value = true;

    try {
      final decoded = await _service.login(
        phone: phone,
        //password: password, //  à envoyer si ton API le demande
      );

      final token = decoded?['token']; //  backend
      final user = decoded?['user'];

      if (token != null) {
        _storage.write('auth_token', token);
        _storage.write('token', token);

        if (user != null) {
          _storage.write('user_id', user['id']);
          _storage.write('user_name', user['name']);
          _storage.write('user_email', user['email']);
          _storage.write('user_phone', user['phone']);
        }

        return true;
      }

      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ========= LOGOUT =========
  void logout() {
    _storage.remove('auth_token');
    _storage.remove('token');

    _storage.remove('user_id');
    _storage.remove('user_name');
    _storage.remove('user_email');
    _storage.remove('user_phone');

    _service.logout();
    Get.offAllNamed(Routes.onboarding);
  }
}