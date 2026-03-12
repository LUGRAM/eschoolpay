import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../models/child_model.dart';

class ChildDetailPage extends StatelessWidget {
  const ChildDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChildModel child = Get.arguments as ChildModel;

    final bool hasPhoto = child.photoPath != null;
    final bool hasInscription = child.extras["school_id"] != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── HEADER avec avatar ───────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primarySoft,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Fond dégradé
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

                  // Cercles décoratifs
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
                        // Avatar
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: hasPhoto
                                ? Image.file(
                              File(child.photoPath!),
                              fit: BoxFit.cover,
                            )
                                : Container(
                              color: Colors.white.withValues(alpha: 0.15),
                              child: Center(
                                child: Text(
                                  child.firstName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Nom complet
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

                        // Badge sexe + matricule
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Badge(
                              icon: child.sexe == "M"
                                  ? Icons.male
                                  : Icons.female,
                              label:
                              child.sexe == "M" ? "Garçon" : "Fille",
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

          // ─── CONTENU ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Infos personnelles ──────────────────────
                  _SectionCard(
                    title: "Informations personnelles",
                    icon: Icons.person_outline_rounded,
                    children: [
                      _InfoRow(
                        label: "Prénom",
                        value: child.firstName,
                      ),
                      _InfoRow(
                        label: "Nom",
                        value: child.lastName,
                      ),
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

                  // ── Infos d'inscription ─────────────────────
                  _SectionCard(
                    title: "Inscription scolaire",
                    icon: Icons.school_outlined,
                    children: hasInscription
                        ? [
                      _InfoRow(
                        label: "Établissement",
                        value: child.displaySchool,
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
                        : [
                      const _EmptyInscription(),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
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
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
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
          // En-tête section
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
                  child: Icon(icon,
                      size: 16, color: AppColors.primarySoft),
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.isNotEmpty ? value : "—",
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
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
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 40,
            color: Colors.grey.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 10),
          const Text(
            "Aucune inscription enregistrée",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Inscrivez cet enfant via le menu Services",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}