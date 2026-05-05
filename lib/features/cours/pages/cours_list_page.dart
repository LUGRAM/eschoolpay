import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_text_field.dart';
import '../controllers/cours_controller.dart';
import '../models/course_model.dart';

class CoursListPage extends StatelessWidget {
  CoursListPage({super.key});

  final CoursController controller = Get.put(CoursController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: const SizedBox(height: 8)),
          Obx(() {
            if (controller.isLoading.value) return _buildShimmerList();
            if (controller.cours.isEmpty) return _buildEmpty();
            return _buildCoursList();
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
        title: const Text(
          'Cours',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.gradientEnd],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.play_circle_outline,
                      color: Colors.white38, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          '${controller.cours.length} cours disponibles',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: AppTextField(
        controller: null, // ou un TextEditingController si tu veux contrôler le champ
        hint: 'Rechercher un cours, matière, niveau…',
        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildCoursList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, i) => _CourseCard(course: controller.cours[i]),
        childCount: controller.cours.length,
      ),
    );
  }

  Widget _buildShimmerList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (_, __) => _ShimmerCourseCard(),
        childCount: 4,
      ),
    );
  }

  Widget _buildEmpty() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined, size: 64, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(
                'Aucun cours trouvé',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Essayez un autre mot-clé',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card individuelle d'un cours
// ─────────────────────────────────────────────────────────────────────────────

class _CourseCard extends StatelessWidget {
  final CourseModel course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/course-detail',
        arguments: {'courseId': course.id},
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnailUrl ?? '',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 160,
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.gradientEnd),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.play_circle_fill,
                            color: Colors.white.withOpacity(0.4), size: 56),
                      ),
                    ),
                  ),
                  // Overlay gradient bas
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge durée
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            course.duration,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Badge type si single video
                  if (course.isSingleVideo)
                    Positioned(
                      top: 10,
                      left: 12,
                      child: _Badge(
                        label: 'Vidéo complète',
                        color: AppColors.gradientEnd,
                      ),
                    ),
                ],
              ),
            ),

            // Infos
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Matière + Niveau
                  Row(
                    children: [
                      _Badge(label: course.subject, color: AppColors.primary),
                      const SizedBox(width: 8),
                      _Badge(
                          label: course.level,
                          color: AppColors.gradientEnd.withOpacity(0.8)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Titre
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    course.description,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Footer — leçons + progression
                  Row(
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: 15, color: AppColors.gradientEnd),
                      const SizedBox(width: 5),
                      Text(
                        '${course.lessonCount} leçon${course.lessonCount > 1 ? 's' : ''}',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 12.5),
                      ),
                      const Spacer(),
                      if (course.progressPercent > 0) ...[
                        SizedBox(
                          width: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: course.progressPercent / 100,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.gradientEnd),
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${course.progressPercent.toInt()}%',
                          style: TextStyle(
                            color: AppColors.gradientEnd,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else
                        TextButton(
                          onPressed: () => Get.toNamed(
                            '/course-detail',
                            arguments: {'courseId': course.id},
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            backgroundColor: AppColors.gradientEnd.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Commencer',
                            style: TextStyle(
                              color: AppColors.gradientEnd,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerCourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _shimmerBox(60, 22),
                      const SizedBox(width: 8),
                      _shimmerBox(44, 22),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _shimmerBox(double.infinity, 16),
                  const SizedBox(height: 6),
                  _shimmerBox(200, 13),
                  const SizedBox(height: 6),
                  _shimmerBox(160, 13),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double w, double h) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(6),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _Badge widget local (cohérent avec design system)
// ─────────────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}