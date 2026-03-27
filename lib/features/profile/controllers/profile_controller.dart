// features/profile/controllers/profile_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_client.dart';
import '../../parent/models/user_model.dart';

class ProfileController extends GetxController {
  final profile = Rxn<UserModel>();
  final isLoading = false.obs;
  final isUploadingPhoto = false.obs;

  final GetStorage _box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  // ── Endpoints fictifs — à remplacer quand le vrai sera prêt ──
  static const _profileEndpoint = '/parent/profile';
  static const _avatarEndpoint  = '/parent/avatar';
  static const _baseStorageUrl  = 'https://eschool.itmaster-africa.com/storage/';

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage(); // chargement immédiat depuis cache
    fetchProfile();     // tente l'API en arrière-plan
  }

  // ─── Charge depuis GetStorage (instantané) ───────────────────
  void _loadFromStorage() {
    profile.value = UserModel(
      id:       _box.read('user_id')?.toString() ?? '0',
      name:     _box.read('user_name')  ?? 'Parent',
      email:    _box.read('user_email') ?? '',
      phone:    _box.read('user_phone') ?? '',
      photoUrl: _resolvePhotoUrl(_box.read('user_photo_url')),
    );
    debugPrint('👤 [ProfileCtrl] Profil chargé depuis storage: ${profile.value?.name}');
  }

  // ─── Persistance dans GetStorage ─────────────────────────────
  void _saveToStorage(UserModel u) {
    _box.write('user_name',      u.name);
    _box.write('user_email',     u.email);
    _box.write('user_phone',     u.phone ?? '');
    _box.write('user_photo_url', u.photoUrl ?? '');
  }

  // ─── Résout les URLs relatives en absolues ───────────────────
  String? _resolvePhotoUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http')) return raw;
    if (raw.startsWith('/')) return '$_baseStorageUrl${raw.substring(1)}';
    return '$_baseStorageUrl$raw';
  }

  // ─── GET /parent/profile — endpoint fictif ───────────────────
  // Quand le vrai endpoint sera prêt, cette méthode fonctionnera
  // automatiquement sans aucun autre changement.
  Future<void> fetchProfile() async {
    try {
      final response = await ApiClient.get(_profileEndpoint);
      debugPrint('👤 [ProfileCtrl] fetchProfile status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] ?? json;

        final fetched = UserModel(
          id:       data['id']?.toString() ?? _box.read('user_id')?.toString() ?? '0',
          name:     data['name']  ?? _box.read('user_name')  ?? 'Parent',
          email:    data['email'] ?? _box.read('user_email') ?? '',
          phone:    data['phone'] ?? _box.read('user_phone') ?? '',
          photoUrl: _resolvePhotoUrl(data['photo_url'] ?? data['photo']),
        );

        profile.value = fetched;
        _saveToStorage(fetched);
      }
      // 404/500 → on garde le cache storage, pas d'erreur affichée
    } catch (e) {
      debugPrint('👤 [ProfileCtrl] fetchProfile ignored (endpoint fictif): $e');
    }
  }

  // ─── Upload photo — POST /parent/avatar (fictif) ─────────────
  Future<void> pickAndUploadAvatar(ImageSource source) async {
    try {
      // 1. Sélection + crop
      final path = await _pickAndCrop(source: source);
      if (path == null) return;

      isUploadingPhoto.value = true;

      // 2. Affichage local immédiat (optimistic UI)
      profile.update((val) => val?.photoUrl = path);

      // 3. Tentative upload vers l'API
      try {
        final streamed = await ApiClient.multipart(
          endpoint: _avatarEndpoint,
          method: 'POST',
          fileField: 'photo',
          file: File(path),
          fields: {},
        );

        final body = await streamed.stream.bytesToString();
        debugPrint('[ProfileCtrl] avatar upload status: ${streamed.statusCode}');
        debugPrint('[ProfileCtrl] avatar upload body: $body');

        if (streamed.statusCode == 200 || streamed.statusCode == 201) {
          final decoded = jsonDecode(body);
          final data = decoded['data'] ?? decoded;
          final serverUrl = _resolvePhotoUrl(
              data['photo_url']?.toString() ?? data['photo']?.toString());

          if (serverUrl != null) {
            profile.update((val) => val?.photoUrl = serverUrl);
            _box.write('user_photo_url', serverUrl);
          } else {
            // Pas d'URL serveur → garde le local
            _box.write('user_photo_url', path);
          }
        } else {
          // Endpoint fictif → garde affichage local
          _box.write('user_photo_url', path);
          debugPrint('📸 [ProfileCtrl] Endpoint fictif, photo locale conservée');
        }
      } catch (e) {
        // Endpoint inexistant → garde affichage local sans crasher
        _box.write('user_photo_url', path);
        debugPrint('📸 [ProfileCtrl] Upload ignoré (endpoint fictif): $e');
      }

      Get.snackbar(
        "Succès", "Photo mise à jour",
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  // ─── PUT /parent/profile (fictif) ────────────────────────────
  Future<void> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    isLoading.value = true;

    try {
      // 1. Tentative API
      try {
        final response = await ApiClient.put(_profileEndpoint, {
          'name':  name,
          'email': email,
          if (phone != null) 'phone': phone,
        });
        debugPrint('[ProfileCtrl] updateProfile status: ${response.statusCode}');
      } catch (e) {
        debugPrint('[ProfileCtrl] updateProfile ignoré (endpoint fictif): $e');
      }

      // 2. Mise à jour locale (toujours)
      profile.update((val) {
        val?.name  = name;
        val?.email = email;
        if (phone != null) val?.phone = phone;
      });

      // 3. Persistance
      _box.write('user_name',  name);
      _box.write('user_email', email);
      if (phone != null) _box.write('user_phone', phone);

      Get.back();
      Get.snackbar("Profil", "Mise à jour réussie");
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Pick & Crop ─────────────────────────────────────────────
  Future<String?> _pickAndCrop({required ImageSource source}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1600,
      );
      if (picked == null) return null;

      if (Platform.isWindows) return picked.path;

      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressQuality: 85,
        maxWidth: 1080,
        maxHeight: 1080,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Ajuster la photo',
            toolbarColor: const Color(0xFF063D66),
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Ajuster la photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      return cropped?.path;
    } catch (_) {
      return null;
    }
  }
}