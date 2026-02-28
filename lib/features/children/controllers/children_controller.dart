import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/child_model.dart';
import '../services/children_service.dart';

class ChildrenController extends GetxController {

  final ChildrenService _service = ChildrenService();
  final children = <ChildModel>[].obs;
  final isLoading = false.obs;

  final GetStorage _box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  int? get parentId => _box.read('parent_model_id');
  bool get isLoggedIn => _box.read("auth_token") != null;

  @override
  void onInit() {
    super.onInit();

    //  Ne charge les enfants QUE si connecté
    if (isLoggedIn) {
      fetchChildren();
    }
  }

  // ================= FETCH =================
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

  // ================= CREATE =================
  Future<bool> createChild(ChildModel child) async {
  try {
      isLoading.value = true;

      final fields = child.toMultipartFields(); // contient déjà parent_model_id
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
  String _convertDate(String input) {
    final parts = input.split('/');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  // ================= IMAGE =================
  Future<String?> pickAndCrop({required ImageSource source}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1600,
      );
      if (picked == null) return null;

      if (Platform.isWindows) {
        return picked.path;
      }

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