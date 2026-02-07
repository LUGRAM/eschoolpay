import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/gradient_button.dart';
import '../controllers/profile_controller.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(); // Adapté pour AppTextField
  final _passwordCtrl = TextEditingController();

  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    final user = controller.profile.value;
    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email;
      _phoneCtrl.text = user.phone ?? "";
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _openPhotoOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Photo de profil",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF063D66)),
              title: const Text("Importer une photo"),
              onTap: () {
                Get.back();
                controller.pickAndUploadAvatar(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF063D66)),
              title: const Text("Prendre une photo"),
              onTap: () {
                Get.back();
                controller.pickAndUploadAvatar(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Modifier le profil"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final user = controller.profile.value;
        if (user == null) return const Center(child: Text("Profil introuvable"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= AVATAR SECTION =================
                Center(
                  child: GestureDetector(
                    onTap: _openPhotoOptions,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: user.photoUrl != null
                              ? NetworkImage(user.photoUrl!)
                              : null,
                          child: user.photoUrl == null
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFF063D66),
                          child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= FORM FIELDS =================
                _label("Nom complet"),
                AppTextField(
                  controller: _nameCtrl,
                  hint: "Votre nom",
                  prefixIcon: const Icon(Icons.person_outline),
                ),

                const SizedBox(height: 15),

                _label("Email"),
                AppTextField(
                  controller: _emailCtrl,
                  hint: "votre@email.com",
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),

                const SizedBox(height: 15),

                _label("Téléphone"),
                AppTextField(
                  controller: _phoneCtrl,
                  hint: "06 00 00 00",
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_android),
                ),

                const SizedBox(height: 30),

                Obx(() => GradientButton(
                  label: controller.isLoading.value ? "Enregistrement..." : "Enregistrer les modifications",
                  onTap: controller.isLoading.value ? () {} : _saveData,
                )),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      controller.updateProfile(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      );
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}