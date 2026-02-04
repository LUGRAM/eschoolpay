// lib/features/profile/controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../parent/models/user_model.dart';

class ProfileController extends GetxController {
  var profile = Rxn<UserModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulation d'un utilisateur connecté au démarrage
    profile.value = UserModel(
      id: "1",
      name: "Parent eSchool",
      email: "parent@example.com",
      phone: "+241 01 02 03 04",
    );
  }

  Future<void> pickAndUploadAvatar(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2)); // Simulation réseau
      profile.update((val) {
        val?.photoUrl = image.path; // Dans un vrai cas, on met l'URL serveur
      });
      isLoading.value = false;
      Get.snackbar("Succès", "Photo mise à jour");
    }
  }

  Future<void> updateProfile({required String name, required String email, String? phone, String? password}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    profile.update((val) {
      val?.name = name;
      val?.email = email;
    });
    isLoading.value = false;
    Get.back(); // Ferme le formulaire
    Get.snackbar("Profil", "Mise à jour réussie");
  }
}

/*

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Simule un profil utilisateur avec une image observable
  var profile = Rxn<dynamic>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialisation bidon pour le test
    profile.value = {'name': 'Parent User', 'photoUrl': null};
  }

  Future<void> pickAndUploadAvatar(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2)); // Simulation
      profile.update((val) => val['photoUrl'] = image.path);
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({required String name, String? email, String? phone, String? password}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.back();
    Get.snackbar("Succès", "Profil mis à jour");
  }
}

* */