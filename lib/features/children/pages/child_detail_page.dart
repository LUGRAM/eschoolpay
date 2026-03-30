// features/children/pages/child_detail_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/children_controller.dart';
import '../models/child_model.dart';

class ChildDetailPage extends StatelessWidget {
  const ChildDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChildModel initialChild = Get.arguments as ChildModel;
    final ctrl = Get.find<ChildrenController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // Récupère la version réactive depuis le controller
        final child = ctrl.children.firstWhereOrNull(
              (c) => c.id == initialChild.id,
        ) ??
            initialChild;

        print("Etablissement: ${child.extras["school_id"]}");

        final bool hasInscription = child.extras["school_id"] != null &&
            child.extras["school_id"]!.isNotEmpty;

        return CustomScrollView(
          slivers: [
            // ─── HEADER ─────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppColors.primarySoft,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Dégradé
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                        ),
                      ),
                    ),
                    // Cercles déco
                    Positioned(
                      top: -40, right: -40,
                      child: Container(
                        width: 160, height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30, left: -30,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    // Avatar + nom
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Avatar cliquable ─────────────────
                          GestureDetector(
                            onTap: () => _showPhotoOptions(context, child, ctrl),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
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
                                    child: Obx(() {
                                      if (ctrl.isUploadingPhoto.value) {
                                        return Container(
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          ),
                                        );
                                      }
                                      return _buildAvatarContent(child);
                                    }),
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
                          const SizedBox(height: 12),

                          // Nom
                          Text(
                            child.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _Badge(
                                icon: child.sexe == "M"
                                    ? Icons.male
                                    : Icons.female,
                                label: child.sexe == "M" ? "Garçon" : "Fille",
                              ),
                              const SizedBox(width: 10),
                              _Badge(
                                icon: Icons.badge_outlined,
                                label: child.matricule.isNotEmpty
                                    ? child.matricule
                                    : "—",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── CONTENU ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Infos personnelles
                    _SectionCard(
                      title: "Informations personnelles",
                      icon: Icons.person_outline_rounded,
                      children: [
                        _InfoRow(label: "Prénom", value: child.firstName),
                        _InfoRow(label: "Nom", value: child.lastName),
                        _InfoRow(
                          label: "Sexe",
                          value: child.sexe == "M" ? "Masculin" : "Féminin",
                        ),
                        _InfoRow(
                          label: "Date de naissance",
                          value: child.birthDate.isNotEmpty
                              ? child.birthDate
                              : "—",
                          isLast: child.birthPlace.isEmpty,
                        ),
                        if (child.birthPlace.isNotEmpty)
                          _InfoRow(
                            label: "Lieu de naissance",
                            value: child.birthPlace,
                            isLast: true,
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Inscription scolaire
                    _SectionCard(
                      title: "Inscription scolaire",
                      icon: Icons.school_outlined,
                      children: hasInscription
                          ? [
                        _InfoRow(
                          label: "Établissement",
                          value: child.schoolName!,
                        ),
                        _InfoRow(
                          label: "Niveau",
                          value: child.displayGrade,
                        ),
                        if (child.academicYear != null &&
                            child.academicYear!.isNotEmpty)
                          _InfoRow(
                            label: "Année scolaire",
                            value: child.academicYear!,
                            isLast: true,
                          ),
                      ]
                          : [const _EmptyInscription()],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ─── Avatar content : réseau > local > initiale ───────────────
  Widget _buildAvatarContent(ChildModel child) {
    // Priorité 1 : URL réseau de l'API
    if (child.photoUrl != null && child.photoUrl!.isNotEmpty) {
      return Image.network(
        child.photoUrl!,
        fit: BoxFit.cover,
        width: 96,
        height: 96,
        errorBuilder: (_, __, ___) => _initialFallback(child),
        loadingBuilder: (_, widget, progress) {
          if (progress == null) return widget;
          return Container(
            color: Colors.white.withValues(alpha: 0.15),
            child: const Center(
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
          );
        },
      );
    }

    // Priorité 2 : chemin local (après crop, avant upload)
    if (child.photoPath != null) {
      return Image.file(
        File(child.photoPath!),
        fit: BoxFit.cover,
        width: 96,
        height: 96,
        errorBuilder: (_, __, ___) => _initialFallback(child),
      );
    }

    // Priorité 3 : initiale
    return _initialFallback(child);
  }

  Widget _initialFallback(ChildModel child) {
    return Container(
      color: Colors.white.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          child.firstName.isNotEmpty
              ? child.firstName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ─── Bottom sheet photo ───────────────────────────────────────
  void _showPhotoOptions(
      BuildContext context,
      ChildModel child,
      ChildrenController ctrl,
      ) {
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
              "Photo de l'enfant",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Color(0xFF063D66)),
              title: const Text("Importer une photo"),
              onTap: () async {
                Get.back();
                await ctrl.updateChildPhoto(
                    child.id!, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: Color(0xFF063D66)),
              title: const Text("Prendre une photo"),
              onTap: () async {
                Get.back();
                if (child.id != null) {
                  await ctrl.updateChildPhoto(child.id!, ImageSource.camera);
                } else {
                  Get.snackbar("Erreur", "ID enfant introuvable");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BADGE ───────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── SECTION CARD ────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          ...children,
        ],
      ),
    );
  }
}

// ─── INFO ROW ────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500)),
              Text(value.isNotEmpty ? value : "—",
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

// ─── EMPTY INSCRIPTION ───────────────────────────────────────────
class _EmptyInscription extends StatelessWidget {
  const _EmptyInscription();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,  // ← occupe toute la largeur
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,  // ← centre explicite
          children: [
            Icon(Icons.school_outlined,
                size: 40, color: Colors.grey.withValues(alpha: 0.4)),
            const SizedBox(height: 10),
            Text(
              "Aucune inscription enregistrée",
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Inscrivez cet enfant via le menu Services",
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}