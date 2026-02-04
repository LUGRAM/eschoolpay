import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/gradient_button.dart';

import '../../schools/controllers/schools_controller.dart';
import '../../schools/models/class_level_model.dart';

import '../controllers/children_controller.dart';
import '../models/child_model.dart';

class AddChildPage extends StatefulWidget {
  const AddChildPage({super.key});

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  final prenomCtrl = TextEditingController();
  final nomCtrl = TextEditingController();
  final dateNaissCtrl = TextEditingController();
  final lieuNaissCtrl = TextEditingController();

  final ChildrenController childrenCtrl = Get.put(ChildrenController());


  @override
  void dispose() {
    prenomCtrl.dispose();
    nomCtrl.dispose();
    dateNaissCtrl.dispose();
    lieuNaissCtrl.dispose();
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
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF063D66)),
              title: const Text("Importer une photo"),
              onTap: () {
                Get.back();
                // childrenCtrl.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF063D66)),
              title: const Text("Prendre une photo"),
              onTap: () {
                Get.back();
                // childrenCtrl.pickImage(ImageSource.camera);
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
        title: const Text("Ajouter un enfant", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.borderGlow.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar + Action Photo
                GestureDetector(
                  onTap: _openPhotoOptions,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 110, width: 110,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE8F1F7)),
                        child: Lottie.asset(
                          "assets/lotties/children_animation.json",
                          height: 140,
                          errorBuilder: (_, __, ___) => const Icon(Icons.child_care, size: 60),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFF063D66),
                        child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Modifier la photo", style: TextStyle(fontSize: 12, color: Colors.grey)),

                const SizedBox(height: 24),

                _buildField("Prénom", prenomCtrl, Icons.person),
                _buildField("Nom", nomCtrl, Icons.person_outline),

                // Date de Naissance avec DatePicker
                _buildField(
                    "Date de naissance",
                    dateNaissCtrl,
                    Icons.calendar_today,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dateNaissCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
                      }
                    }
                ),

                _buildField("Lieu de naissance", lieuNaissCtrl, Icons.location_on_outlined),

                const SizedBox(height: 26),

                GradientButton(
                  label: "Enregistrer l'enfant",
                  onTap: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      children: [
        _Label(label),
        AppTextField(
          controller: ctrl,
          hint: label,
          prefixIcon: Icon(icon),
          readOnly: readOnly,
          onTap: onTap,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

// Dans lib/features/children/pages/add_child_page.dart

  void _submit() {
    FocusScope.of(context).unfocus();

    if (prenomCtrl.text.trim().isEmpty ||
        nomCtrl.text.trim().isEmpty ||
        dateNaissCtrl.text.trim().isEmpty ||
        lieuNaissCtrl.text.trim().isEmpty) {
      Get.snackbar("Erreur", "Tous les champs sont obligatoires");
      return;
    }

    final newChild = ChildModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: prenomCtrl.text.trim(),
      lastName: nomCtrl.text.trim(),
      birthDate: dateNaissCtrl.text.trim(),
      birthPlace: lieuNaissCtrl.text.trim(),
    );

    childrenCtrl.addChild(newChild);

    // ✅ navigation claire et sûre
    Get.offNamed('/children');
  }

}/// Label simple et cohérent
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
