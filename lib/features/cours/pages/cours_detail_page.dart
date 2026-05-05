import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../controllers/cours_controller.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';

class CourseDetailPage extends StatelessWidget {
  CourseDetailPage({super.key});

  final CourseDetailController controller = Get.put(CourseDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) return _buildShimmer();
        final course = controller.course.value;
        if (course == null) return _buildError();
        return _buildContent(course);
      }),
    );
  }

  Widget _buildContent(CourseModel course) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(course),
        SliverToBoxAdapter(child: _buildHeader(course)),
        SliverToBoxAdapter(child: _buildProgressSection(course)),
        SliverToBoxAdapter(child: _buildCourseContentSection(course)),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildSliverAppBar(CourseModel course) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            CachedNetworkImage(
              imageUrl: course.thumbnailUrl ?? '',
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.play_circle_fill,
                    size: 72, color: Colors.white.withOpacity(0.3)),
              ),
            ),
            // Scrim gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CourseModel course) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges
          Row(
            children: [
              _Badge(label: course.subject, color: AppColors.primary),
              const SizedBox(width: 8),
              _Badge(
                  label: course.level,
                  color: AppColors.gradientEnd.withOpacity(0.85)),
              if (course.isSingleVideo) ...[
                const SizedBox(width: 8),
                _Badge(label: 'Vidéo complète', color: Colors.teal),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Titre
          Text(
            course.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            course.description,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Stats row
          _SectionCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.access_time_outlined,
                  value: course.duration,
                  label: 'Durée',
                ),
                _divider(),
                _StatItem(
                  icon: Icons.menu_book_outlined,
                  value: '${course.lessonCount}',
                  label: 'Leçon${course.lessonCount > 1 ? 's' : ''}',
                ),
                _divider(),
                _StatItem(
                  icon: Icons.layers_outlined,
                  value: course.isSingleVideo
                      ? '1'
                      : '${course.sections.length}',
                  label: 'Section${course.sections.length > 1 ? 's' : ''}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // CTA bouton commencer / continuer
          GradientButton(
            label: course.progressPercent > 0
                ? 'Continuer le cours'
                : 'Commencer le cours',
            onTap: () {
              final firstLesson = course.allLessons.first;
              controller.openLesson(firstLesson);
            },
            //icon: Icons.play_arrow_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(CourseModel course) {
    if (course.progressPercent <= 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: _SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progression',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${course.progressPercent.toInt()}%',
                  style: const TextStyle(
                    color: AppColors.gradientEnd,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: course.progressPercent / 100,
                backgroundColor: AppColors.border,
                valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.gradientEnd),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseContentSection(CourseModel course) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contenu du cours',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (course.isSingleVideo && course.singleLesson != null)
            _LessonTile(
              lesson: course.singleLesson!,
              index: 1,
              onTap: () => controller.openLesson(course.singleLesson!),
              isCompleted: controller.isLessonCompleted(course.singleLesson!.id)
            )
          else
            ...course.sections.map((section) =>
                _SectionAccordion(section: section, controller: controller)),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 220, color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _shimmerBox(70, 24),
                    const SizedBox(width: 8),
                    _shimmerBox(50, 24),
                  ]),
                  const SizedBox(height: 12),
                  _shimmerBox(double.infinity, 22),
                  const SizedBox(height: 8),
                  _shimmerBox(double.infinity, 14),
                  const SizedBox(height: 6),
                  _shimmerBox(260, 14),
                  const SizedBox(height: 20),
                  _shimmerBox(double.infinity, 80),
                  const SizedBox(height: 16),
                  _shimmerBox(double.infinity, 52),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Cours introuvable'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(double w, double h) => Container(
    width: w,
    height: h,
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  Widget _divider() => Container(
      width: 1, height: 36, color: AppColors.border);
}

// ─────────────────────────────────────────────────────────────────────────────
// Section accordéon
// ─────────────────────────────────────────────────────────────────────────────

class _SectionAccordion extends StatelessWidget {
  final CourseSectionModel section;
  final CourseDetailController controller;

  const _SectionAccordion(
      {required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOpen = controller.isSectionExpanded(section.id);
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Header cliquable
            InkWell(
              onTap: () => controller.toggleSection(section.id),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                  bottom: Radius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.gradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${section.order}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${section.lessons.length} leçon${section.lessons.length > 1 ? 's' : ''}',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            // Lessons list
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: section.lessons
                    .map((l) => _LessonTile(
                  lesson: l,
                  index: l.order,
                  onTap: () => controller.openLesson(l),
                  showDivider: l != section.lessons.last,
                  isCompleted: controller.isLessonCompleted(l.id)
                ))
                    .toList(),
              ),
              crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Lesson tile
// ─────────────────────────────────────────────────────────────────────────────

class _LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final int index;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isCompleted; // ← NOUVEAU

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.onTap,
    this.showDivider = false,
    this.isCompleted = false, // ← NOUVEAU
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Icône type leçon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withOpacity(0.12)
                        : lesson.isVideo
                        ? AppColors.gradientEnd.withOpacity(0.12)
                        : AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : lesson.isVideo
                        ? Icons.play_circle_outline
                        : Icons.article_outlined,
                    size: 20,
                    color: isCompleted
                        ? Colors.green
                        : lesson.isVideo
                        ? AppColors.gradientEnd
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: TextStyle(
                          color: isCompleted
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            lesson.isVideo ? 'Vidéo' : 'Lecture',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 11),
                          ),
                          const SizedBox(width: 6),
                          Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                  color: AppColors.textMuted,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(lesson.duration,
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 11)),
                          if (isCompleted) ...[
                            const SizedBox(width: 6),
                            Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Terminée',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    size: 18, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              thickness: 1,
              color: AppColors.border,
              indent: 62),
      ],
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.gradientEnd, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}

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
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}