import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/gradient_button.dart';

import '../controllers/children_controller.dart';
import '../models/child_model.dart';

class AddChildPage extends StatefulWidget {
  const AddChildPage({super.key});

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  final _formKey = GlobalKey<FormState>();

  final prenomCtrl = TextEditingController();
  final nomCtrl = TextEditingController();
  final dateNaissCtrl = TextEditingController();
  final lieuNaissCtrl = TextEditingController();

  final ChildrenController childrenCtrl = Get.find<ChildrenController>();

  //  Regex de validation
  final RegExp _nameRegExp = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']{2,30}$");
  final RegExp _placeRegExp = RegExp(r"^[a-zA-ZÀ-ÿ0-9\s\-,']{2,50}$");

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
                color: AppColors.textPrimary,
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
        title: const Text(
          "Ajouter un enfant",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                          height: 110,
                          width: 110,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8F1F7),
                          ),
                          child: Lottie.asset(
                            "assets/lotties/children_animation.json",
                            height: 140,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.child_care, size: 60),
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
                  const Text(
                    "Modifier la photo",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Champs avec validation
                  _buildField(
                    "Prénom",
                    prenomCtrl,
                    Icons.person,
                    validator: _validateName,
                  ),
                  _buildField(
                    "Nom",
                    nomCtrl,
                    Icons.person_outline,
                    validator: _validateName,
                  ),
                  _buildField(
                    "Date de naissance",
                    dateNaissCtrl,
                    Icons.calendar_today,
                    readOnly: true,
                    validator: _validateDate,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dateNaissCtrl.text =
                        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                      }
                    },
                  ),
                  _buildField(
                    "Lieu de naissance",
                    lieuNaissCtrl,
                    Icons.location_on_outlined,
                    validator: _validatePlace,
                  ),

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
      ),
    );
  }

  // Validateurs
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Ce champ est obligatoire";
    }
    if (!_nameRegExp.hasMatch(value.trim())) {
      return "Lettres uniquement (2-30 caractères)";
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Veuillez sélectionner une date";
    }
    return null;
  }

  String? _validatePlace(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Ce champ est obligatoire";
    }
    if (!_placeRegExp.hasMatch(value.trim())) {
      return "Format invalide (2-50 caractères)";
    }
    return null;
  }

  Widget _buildField(
      String label,
      TextEditingController ctrl,
      IconData icon, {
        bool readOnly = false,
        VoidCallback? onTap,
        String? Function(String?)? validator,
      }) {
    return Column(
      children: [
        _Label(label),
        AppTextField(
          controller: ctrl,
          hint: label,
          prefixIcon: Icon(icon),
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // Soumission optimisée
  void _submit() {
    FocusScope.of(context).unfocus();

    // Validation du formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newChild = ChildModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: prenomCtrl.text.trim(),
      lastName: nomCtrl.text.trim(),
      birthDate: dateNaissCtrl.text.trim(),
      birthPlace: lieuNaissCtrl.text.trim(),
    );

    // ✅ Ajout silencieux (pas de snackbar ici)
    childrenCtrl.addChild(newChild);

    // ✅ Navigation immédiate
    Get.back();

    Future.microtask(() {
      Get.showSnackbar(
          GetSnackBar(
            title: "Succès",
            message: "${newChild.firstName} a été ajouté(e)",
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade800.withValues(alpha: 0.7),
            barBlur: 20,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          ),
      );
    });
  }
}

/// Label simple et cohérent
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
