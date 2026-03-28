// features/children/controllers/children_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/api_client.dart';
import '../models/child_model.dart';
import '../services/children_service.dart';

class ChildrenController extends GetxController {
  final ChildrenService _service = ChildrenService();
  final children = <ChildModel>[].obs;
  final isLoading = false.obs;
  final isUploadingPhoto = false.obs;

  final GetStorage _box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  int? get parentId => _box.read('parent_model_id');
  bool get isLoggedIn => _box.read("auth_token") != null;

  @override
  void onInit() {
    super.onInit();
    debugPrint('ChildrenController isLoggedIn: $isLoggedIn');
    if (isLoggedIn) fetchChildren();
  }

  // ─── FETCH ───────────────────────────────────────────────────
  Future<void> fetchChildren() async {
    if (!isLoggedIn) return;
    try {
      isLoading.value = true;
      final result = await _service.fetchChildren();
      children.assignAll(result);
    } catch (e) {
      if (e.toString().contains("401")) {
        Get.snackbar("Session expirée", "Veuillez vous reconnecter");
      } else {
        Get.snackbar("Erreur", "Impossible de charger les enfants");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── CREATE ──────────────────────────────────────────────────
  Future<bool> createChild(ChildModel child) async {
    try {
      isLoading.value = true;
      final fields = child.toMultipartFields();
      final photo = child.photoPath != null ? File(child.photoPath!) : null;
      await _service.createChild(fields: fields, photo: photo);
      await fetchChildren();
      return true;
    } catch (e) {
      debugPrint("createChild error: $e");
      Get.snackbar("Erreur", e.toString().replaceAll("Exception: ", ""));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── UPDATE PHOTO ENFANT ──────────────────────────────────────
  // Appelle PUT /api/eleves/{id} avec la photo en multipart
  Future<void> updateChildPhoto(String childId, ImageSource source) async {
    try {
      // 1. Sélection + crop
      final path = await pickAndCrop(source: source);
      if (path == null) return;

      isUploadingPhoto.value = true;

      // 2. Upload vers l'API
      final streamed = await ApiClient.multipart(
        endpoint: "/eleves/$childId",
        method: 'POST', // utilise POST avec _method=PUT si l'API le requiert
        fileField: "photo",
        file: File(path),
        fields: {"_method": "PUT"}, // Laravel method spoofing
      );

      final body = await streamed.stream.bytesToString();
      debugPrint('📸 updateChildPhoto status: ${streamed.statusCode}');
      debugPrint('📸 updateChildPhoto body: $body');

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final decoded = jsonDecode(body);
        final data = decoded['data'] ?? decoded;

        // 3. Récupère l'URL retournée par l'API
        final newPhotoUrl = data['photo']?.toString() ??
            data['photo_url']?.toString();

        // 4. Met à jour le model en mémoire
        final index = children.indexWhere((c) => c.id == childId);
        if (index != -1) {
          children[index] = children[index].copyWith(
            photoUrl: newPhotoUrl,
            photoPath: path, // garde le local en fallback
          );
          children.refresh();
        }

        Get.snackbar("Succès", "Photo mise à jour",
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade800);
      } else {
        Get.snackbar("Erreur", "Impossible de mettre à jour la photo");
      }
    } catch (e) {
      debugPrint("updateChildPhoto error: $e");
      Get.snackbar("Erreur", "Une erreur est survenue");
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  // ─── UPDATE EXTRAS ────────────────────────────────────────────
  void updateChildExtras(String childId, Map<String, String> newExtras) {
    final index = children.indexWhere((c) => c.id == childId);
    if (index == -1) return;
    final updated = children[index].copyWith(extras: newExtras);
    children[index] = updated;
    children.refresh();
  }

  // ─── PICK & CROP ─────────────────────────────────────────────
  Future<String?> pickAndCrop({required ImageSource source}) async {
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