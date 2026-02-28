import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/children_controller.dart';
import '../models/child_model.dart';

class AddChildPage extends StatefulWidget {
  const AddChildPage({super.key});

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  final _formKey = GlobalKey<FormState>();

  final authCtrl = Get.find<AuthController>();
  late final int parentId = authCtrl.userId!;

  final ChildrenController childrenCtrl = Get.find<ChildrenController>();

  final prenomCtrl = TextEditingController();
  final nomCtrl = TextEditingController();
  final dateNaissCtrl = TextEditingController();
  final lieuNaissCtrl = TextEditingController();

  // Regex
  final RegExp _nameRegExp = RegExp(r"^[a-zA-ZÀ-ÿ\s\-']{2,30}$");
  final RegExp _placeRegExp = RegExp(r"^[a-zA-ZÀ-ÿ0-9\s\-,']{2,50}$");

  String _sexe = "M"; // M/F
  String? _photoPath; // chemin local après crop

  @override
  void dispose() {
    prenomCtrl.dispose();
    nomCtrl.dispose();
    dateNaissCtrl.dispose();
    lieuNaissCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndCrop(ImageSource source) async {
    final path = await childrenCtrl.pickAndCrop(source: source);
    if (!mounted) return;
    if (path != null) setState(() => _photoPath = path);
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
              onTap: () async {
                Get.back();
                await _pickAndCrop(ImageSource.gallery);
              },
            ),

            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF063D66)),
              title: const Text("Prendre une photo"),
              onTap: () async {
                Get.back();
                await _pickAndCrop(ImageSource.camera);
              },
            ),

            if (_photoPath != null) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text("Retirer la photo"),
                onTap: () {
                  Get.back();
                  setState(() => _photoPath = null);
                },
              ),
            ],
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
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border, width: 1.4),
              ),
              child: Column(
                children: [
                  // Avatar
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
                          child: ClipOval(
                            child: _photoPath != null
                                ? Image.file(
                              File(_photoPath!),
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            )
                                : Lottie.asset(
                              "assets/lotties/children_animation.json",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.child_care, size: 60),
                            ),
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
                  Text(
                    _photoPath == null ? "Ajouter une photo" : "Modifier la photo",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 18),

                  // Sexe
                  _buildSexeSelector(),

                  // Champs
                  _buildField("Prénom", prenomCtrl, Icons.person, validator: _validateName),
                  _buildField("Nom", nomCtrl, Icons.person_outline, validator: _validateName),
                  _buildField(
                    "Date de naissance",
                    dateNaissCtrl,
                    Icons.calendar_today,
                    readOnly: true,
                    validator: _validateDate,
                    onTap: () async {
                      final picked = await showDatePicker(
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
                  _buildField("Lieu de naissance", lieuNaissCtrl, Icons.location_on_outlined,
                      validator: _validatePlace),

                  const SizedBox(height: 22),

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

  Widget _buildSexeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label("Sexe"),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text("Masculin"),
                selected: _sexe == "M",
                onSelected: (_) => setState(() => _sexe = "M"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ChoiceChip(
                label: const Text("Féminin"),
                selected: _sexe == "F",
                onSelected: (_) => setState(() => _sexe = "F"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Ce champ est obligatoire";
    if (!_nameRegExp.hasMatch(value.trim())) return "Lettres uniquement (2-30 caractères)";
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.trim().isEmpty) return "Veuillez sélectionner une date";
    return null;
  }

  String? _validatePlace(String? value) {
    if (value == null || value.trim().isEmpty) return "Ce champ est obligatoire";
    if (!_placeRegExp.hasMatch(value.trim())) return "Format invalide (2-50 caractères)";
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

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final newChild = ChildModel(
      firstName: prenomCtrl.text.trim(),
      lastName: nomCtrl.text.trim(),
      birthDate: dateNaissCtrl.text.trim(),
      birthPlace: lieuNaissCtrl.text.trim(),
      sexe: _sexe,
      matricule: ChildModel.generateMatricule(),
      parentId: parentId,
      photoPath: _photoPath,
    );

    final success = await childrenCtrl.createChild(newChild);
    if (!mounted) return;
    if (success) {
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: "Enfant ajouté avec succès",
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      ));
    }
  }
}

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