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
  final _phoneCtrl = TextEditingController();
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
      body: Obx(() {
        final user = controller.profile.value;
        if (user == null) {
          return const Center(child: Text("Profil introuvable"));
        }

        return CustomScrollView(
          slivers: [
            // ─── HEADER identique au ChildDetailPage ─────────────
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: AppColors.primarySoft,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
              title: const Text(
                "Modifier le profil",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Dégradé identique
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF063D66),
                            Color(0xFF1976D2),
                          ],
                        ),
                      ),
                    ),

                    // Cercles décoratifs identiques
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    // Avatar + nom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Avatar cliquable
                          GestureDetector(
                            onTap: _openPhotoOptions,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: user.photoUrl != null
                                        ? Image.network(
                                      user.photoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _avatarFallback(user.name),
                                    )
                                        : _avatarFallback(user.name),
                                  ),
                                ),
                                // Badge caméra
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: Color(0xFF063D66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Nom
                          Text(
                            user.name.isNotEmpty ? user.name : "Mon profil",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Badge rôle
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_user_outlined,
                                    size: 13, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "Parent",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── FORMULAIRE ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // ── Section coordonnées ───────────────────
                      _SectionCard(
                        title: "Informations personnelles",
                        icon: Icons.person_outline_rounded,
                        child: Column(
                          children: [
                            _FieldRow(
                              label: "Nom complet",
                              child: AppTextField(
                                controller: _nameCtrl,
                                hint: "Votre nom",
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _FieldRow(
                              label: "Email",
                              child: AppTextField(
                                controller: _emailCtrl,
                                hint: "votre@email.com",
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _FieldRow(
                              label: "Téléphone",
                              isLast: true,
                              child: AppTextField(
                                controller: _phoneCtrl,
                                hint: "07x xx xx xx",
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(Icons.phone_android),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Bouton enregistrer ────────────────────
                      Obx(() => GradientButton(
                        label: controller.isLoading.value
                            ? "Enregistrement..."
                            : "Enregistrer les modifications",
                        onTap: controller.isLoading.value
                            ? null
                            : _saveData,
                      )),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ─── Avatar fallback avec initiale ───────────────────────────
  Widget _avatarFallback(String name) {
    return Container(
      color: Colors.white.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : "P",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
}

// ─── SECTION CARD ────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primarySoft),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── FIELD ROW avec label ─────────────────────────────────────────
class _FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isLast;

  const _FieldRow({
    required this.label,
    required this.child,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        child,
        if (!isLast) const SizedBox(height: 4),
      ],
    );
  }
}