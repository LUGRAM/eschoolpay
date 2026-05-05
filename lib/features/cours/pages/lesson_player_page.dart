import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/gradient_button.dart';
import '../controllers/cours_controller.dart';
import '../models/lesson_model.dart';

class LessonPlayerPage extends StatefulWidget {
  const LessonPlayerPage({super.key});

  @override
  State<LessonPlayerPage> createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  final LessonController controller = Get.put(LessonController());

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    ever(controller.lesson, _onLessonChanged);
  }

  void _onLessonChanged(LessonModel? lesson) {
    if (lesson == null) return;
    if (lesson.isVideo && lesson.videoUrl != null) {
      _initializeVideo(lesson.videoUrl!);
    } else {
      _disposeVideo();
    }
  }

  Future<void> _initializeVideo(String url) async {
    if (url == _currentVideoUrl) return;
    _disposeVideo();
    setState(() => _isVideoInitialized = false);
    _currentVideoUrl = url;

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.gradientEnd,
        handleColor: AppColors.gradientEnd,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white38,
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.gradientEnd),
        ),
      ),
    );

    if (mounted) setState(() => _isVideoInitialized = true);
  }

  void _disposeVideo() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _isVideoInitialized = false;
    _currentVideoUrl = null;
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) return _buildShimmer();
        final lesson = controller.lesson.value;
        if (lesson == null) return _buildError();
        return _buildContent(lesson);
      }),
    );
  }

  Widget _buildContent(LessonModel lesson) {
    return Column(
      children: [
        // Zone vidéo ou header texte
        lesson.isVideo ? _buildVideoZone(lesson) : _buildTextHeader(lesson),

        // Corps scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLessonMeta(lesson),
                _buildCompletionBanner(),
                const SizedBox(height: 16),
                if (lesson.isText && lesson.content != null)
                  _buildTextContent(lesson.content!),
                const SizedBox(height: 24),
                _buildProgressIndicator(),
                const SizedBox(height: 20),
                _buildNavigation(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoZone(LessonModel lesson) {
    return Container(
      color: Colors.black,
      height: 240,
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          // Player
          if (_isVideoInitialized && _chewieController != null)
            Chewie(controller: _chewieController!)
          else
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.gradientEnd,
                    strokeWidth: 2.5,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chargement de la vidéo…',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextHeader(LessonModel lesson) {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Lecture',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonMeta(LessonModel lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lesson.isVideo)
          Text(
            lesson.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: lesson.isVideo
                    ? AppColors.gradientEnd.withOpacity(0.12)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    lesson.isVideo
                        ? Icons.videocam_outlined
                        : Icons.article_outlined,
                    size: 13,
                    color: lesson.isVideo
                        ? AppColors.gradientEnd
                        : AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    lesson.isVideo ? 'Vidéo' : 'Lecture',
                    style: TextStyle(
                      color: lesson.isVideo
                          ? AppColors.gradientEnd
                          : AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              lesson.duration,
              style:
              TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextContent(String content) {
    final lines = content.split('\n');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          if (line.isEmpty) return const SizedBox(height: 8);

          // Titres emoji
          if (line.startsWith('📌') ||
              line.startsWith('📝') ||
              line.startsWith('💡') ||
              line.startsWith('✏️') ||
              line.startsWith('📋') ||
              line.startsWith('🎯') ||
              line.startsWith('🧊') ||
              line.startsWith('💧') ||
              line.startsWith('💨') ||
              line.startsWith('🌿') ||
              line.startsWith('👑') ||
              line.startsWith('🔹') ||
              line.startsWith('📅') ||
              line.startsWith('✅')) {
            return Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                line,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            );
          }

          // Séparateur ---
          if (line.trim() == '---') {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.border, height: 1),
            );
          }

          // Étape numérotée
          final isStep = RegExp(r'^Étape \d+').hasMatch(line);
          if (isStep) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 2),
              child: Text(
                line,
                style: const TextStyle(
                  color: AppColors.gradientEnd,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          // Ligne standard
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              line,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.5,
                height: 1.6,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (controller.totalLessons <= 1) return const SizedBox.shrink();

    return Center(
      child: Column(
        children: [
          Text(
            'Leçon ${controller.lessonNumber} sur ${controller.totalLessons}',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: controller.currentIndex.value,
            count: controller.totalLessons,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.gradientEnd,
              dotColor: AppColors.border,
              expansionFactor: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        if (controller.hasPrevious)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _disposeVideo();
                controller.goToPrevious();
              },
              icon: const Icon(Icons.arrow_back_ios, size: 14),
              label: const Text('Précédente'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (controller.hasPrevious && controller.hasNext)
          const SizedBox(width: 12),
        if (controller.hasNext || !controller.hasPrevious)
          Expanded(
            child: GradientButton(
              label: controller.hasNext ? 'Suivante' : 'Terminer',
              onTap: () {
                _disposeVideo();
                controller.goToNext();
              },
              /*icon: controller.hasNext
                  ? Icons.arrow_forward_ios
                  : Icons.check_circle_outline,*/
            ),
          ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            height: 240,
            color: Colors.grey.shade800,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(
                    height: 14, width: 120, color: Colors.grey.shade300),
                const SizedBox(height: 20),
                Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(18),
                    )),
              ],
            ),
          ),
        ],
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
          const Text('Impossible de charger cette leçon'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionBanner() {
    return Obx(() {
      final isComplete = controller.currentLessonCompleted.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isComplete
              ? Colors.green.withOpacity(0.1)
              : AppColors.gradientEnd.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isComplete
                ? Colors.green.withOpacity(0.3)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isComplete ? Colors.green : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isComplete
                    ? 'Leçon terminée — progression enregistrée'
                    : 'Marquez la leçon comme terminée quand vous avez fini',
                style: TextStyle(
                  color: isComplete ? Colors.green : AppColors.textMuted,
                  fontSize: 13,
                  fontWeight:
                  isComplete ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (!isComplete)
              GestureDetector(
                onTap: controller.markCurrentAsComplete,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Terminer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}