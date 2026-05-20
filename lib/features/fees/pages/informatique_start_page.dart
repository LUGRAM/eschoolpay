import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/controllers/annee_scolaire_controller.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../../children/controllers/children_controller.dart';
import '../../children/models/child_model.dart';
import '../../informatique/controllers/informatique_controller.dart';
import '../../informatique/models/informatique_option.dart';
import '../controllers/fees_controller.dart';

class InformatiqueStartPage extends StatelessWidget {
  const InformatiqueStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final informatiqueCtrl = Get.put(InformatiqueController());
    final childrenCtrl = Get.find<ChildrenController>();
    final anneeCtrl = Get.find<AnneeScolaireController>();

    final selectedYear = anneeCtrl.selectedYear.value;
    final normalizedYear = selectedYear == null
        ? null
        : anneeCtrl.schoolYears.firstWhereOrNull(
            (e) => e.id == selectedYear.id,
          );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeroHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Sélection enfant ────────────────────────────────
                    const Text(
                      'Enfant',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Obx(() {
                      final eligible = childrenCtrl.children
                          .where((c) => c.schoolId != null)
                          .toList();

                      if (eligible.isEmpty) {
                        return _infoBox(
                          color: Colors.orange,
                          icon: Icons.info_outline,
                          message:
                              'Aucun enfant inscrit. Veuillez d\'abord inscrire un enfant dans un établissement.',
                        );
                      }

                      return DropdownButtonFormField<ChildModel>(
                        initialValue: informatiqueCtrl.selectedChild,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        hint: const Text('Sélectionnez un enfant'),
                        items: eligible
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                    '${c.fullName} (${c.displaySchool})'),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val?.id != null && normalizedYear != null) {
                            informatiqueCtrl.selectChildAndLoad(val!);
                          }
                        },
                      );
                    }),

                    const SizedBox(height: 24),

                    // ─── En-tête section formations ──────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nos formations',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Choisissez votre niveau',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Pastilles de progression visuelle
                        Row(
                          children: List.generate(
                            3,
                            (i) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i == 0
                                    ? const Color(0xFF1976D2)
                                    : i == 1
                                        ? const Color(0xFF0D47A1)
                                        : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ─── Cards ───────────────────────────────────────────
                    Obx(() {
                      final feesCtrl = Get.find<FeesController>();

                      if (informatiqueCtrl.selectedChild == null) {
                        return _infoBox(
                          color: Colors.grey,
                          icon: Icons.touch_app_outlined,
                          message:
                              'Sélectionnez un enfant pour voir les formations disponibles',
                        );
                      }

                      if (feesCtrl.isLoadingFrais.value) {
                        return const _ShimmerCards();
                      }

                      final options = informatiqueCtrl.options;

                      return Column(
                        children: options
                            .asMap()
                            .entries
                            .map(
                              (e) => _FormationCard(
                                option: e.value,
                                index: e.key,
                                informatiqueCtrl: informatiqueCtrl,
                              ),
                            )
                            .toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Hero header ─────────────────────────────────────────────────────────────
  Widget _buildHeroHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1976D2)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -22,
            right: -22,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            left: 24,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Text(
                        'Service éducatif',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5),
                  ),
                  child: const Icon(Icons.computer,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cours d\'Informatique',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Apprenez à votre rythme avec nos formateurs certifiés',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(
      {required Color color,
      required IconData icon,
      required String message}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
    );
  }
}

// ─── Card de formation premium ────────────────────────────────────────────────
class _FormationCard extends StatelessWidget {
  final InformatiqueOption option;
  final int index;
  final InformatiqueController informatiqueCtrl;

  const _FormationCard({
    required this.option,
    required this.index,
    required this.informatiqueCtrl,
  });

  static const _accentColors = [
    Color(0xFF1976D2), // Débutant
    Color(0xFF0D47A1), // Intermédiaire
    AppColors.primary, // Avancé
  ];

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColors[index.clamp(0, 2)];
    final levelDots = index + 1; // 1, 2, 3 dots

    return Obx(() {
      final isSelected =
          informatiqueCtrl.selectedOption.value?.niveau == option.niveau;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // ─ Corps de la card ─────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            margin: EdgeInsets.only(
              bottom: 20,
              top: option.badge != null ? 10 : 0,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.05)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border(
                left: BorderSide(color: accentColor, width: 4),
                top: BorderSide(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.4)
                      : AppColors.border,
                ),
                right: BorderSide(color: AppColors.border),
                bottom: BorderSide(color: AppColors.border),
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(
                      alpha: option.isHighlighted
                          ? (isSelected ? 0.20 : 0.13)
                          : (isSelected ? 0.12 : 0.07)),
                  blurRadius: option.isHighlighted ? 22 : 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─ En-tête : icône + niveau + dots + chip réduction ─
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(option.icon,
                            color: accentColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge niveau + dots
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    option.niveau.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Dots progression
                                Row(
                                  children: List.generate(
                                    3,
                                    (i) => Container(
                                      width: 7,
                                      height: 7,
                                      margin:
                                          const EdgeInsets.only(right: 3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: i < levelDots
                                            ? accentColor
                                            : accentColor.withValues(
                                                alpha: 0.18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              option.titre,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chip réduction
                      if (option.reduction != null &&
                          option.reduction! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.green.shade200),
                          ),
                          child: Text(
                            '- ${option.reduction!.toInt()} F',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ─ Description ──────────────────────────────────────
                  Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ─ Features 2×2 ─────────────────────────────────────
                  if (option.features.length >= 4) ...[
                    _featureRow(
                        option.features[0], option.features[1], accentColor),
                    const SizedBox(height: 6),
                    _featureRow(
                        option.features[2], option.features[3], accentColor),
                    const SizedBox(height: 14),
                  ],

                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 14),

                  // ─ Prix + Bouton ─────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatPrix(option.montant),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: accentColor,
                            ),
                          ),
                          Text(
                            'par ${option.duree}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 130,
                        child: GradientButton(
                          label: 'S\'inscrire',
                          onTap: () {
                            informatiqueCtrl.selectOption(option);
                            if (informatiqueCtrl.selectedOption.value !=
                                null) {
                              Get.toNamed(
                                Routes.payment,
                                arguments: {
                                  'amount': option.montant.toInt(),
                                  'service':
                                      'Cours Informatique - ${option.niveau}',
                                  'childName': informatiqueCtrl
                                          .selectedChild
                                          ?.fullName ??
                                      '',
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─ Badge flottant ────────────────────────────────────────
          if (option.badge != null)
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientStart,
                      AppColors.gradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientEnd.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      option.badge!.contains('Certification')
                          ? Icons.workspace_premium_rounded
                          : Icons.local_fire_department_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      option.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _featureRow(String f1, String f2, Color accent) {
    return Row(
      children: [
        Expanded(child: _featureItem(f1, accent)),
        const SizedBox(width: 8),
        Expanded(child: _featureItem(f2, accent)),
      ],
    );
  }

  Widget _featureItem(String label, Color accent) {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded,
            size: 14, color: accent),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatPrix(double montant) {
    final s = montant.toInt().toString();
    if (s.length <= 3) return '$s FCFA';
    final idx = s.length - 3;
    return '${s.substring(0, idx)} ${s.substring(idx)} FCFA';
  }
}

// ─── Shimmer ──────────────────────────────────────────────────────────────────
class _ShimmerCards extends StatelessWidget {
  const _ShimmerCards();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          3,
          (i) => Container(
            margin: EdgeInsets.only(bottom: 20, top: i == 0 ? 0 : 0),
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
