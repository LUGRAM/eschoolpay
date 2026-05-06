import 'package:get/get.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../services/cours_service.dart';
import '../services/progress_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CoursController — liste des cours
// ─────────────────────────────────────────────────────────────────────────────

class CoursController extends GetxController {
  final CoursService _coursService = CoursService();
  final ProgressService _progressService = ProgressService();

  final RxList<CourseModel> cours = <CourseModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCours();
    debounce(searchQuery, (_) => loadCours(),
        time: const Duration(milliseconds: 400));
  }

  Future<void> loadCours() async {
    isLoading.value = true;
    try {
      final result = await _coursService.fetchCours(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      // Enrichir chaque cours avec sa progression locale
      final enriched = await Future.wait(result.map((c) async {
        final progress = await _progressService.getCourseProgress(
            c.id, c.allLessons.length);
        return c.copyWith(progressPercent: progress);
      }));
      cours.assignAll(enriched);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les cours.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) => searchQuery.value = value;
  void refreshCours() => loadCours();
}

// ─────────────────────────────────────────────────────────────────────────────
// CourseDetailController — détail + sections accordéon
// ─────────────────────────────────────────────────────────────────────────────

class CourseDetailController extends GetxController {
  final CoursService _coursService = CoursService();
  final ProgressService _progressService = ProgressService();

  final Rx<CourseModel?> course = Rx<CourseModel?>(null);
  final RxBool isLoading = true.obs;
  final RxSet<String> expandedSections = <String>{}.obs;
  final RxSet<String> completedLessons = <String>{}.obs;
  final RxDouble progressPercent = 0.0.obs;

  String get courseId => Get.arguments['courseId'] as String;

  @override
  void onInit() {
    super.onInit();
    loadCourseDetail();
  }

  Future<void> loadCourseDetail() async {
    isLoading.value = true;
    try {
      final result = await _coursService.fetchCourseDetail(courseId);
      course.value = result;
      if (result.sections.isNotEmpty) {
        expandedSections.add(result.sections.first.id);
      }
      await _loadProgress();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger le cours.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProgress() async {
    final completed = await _progressService.getCompletedLessons(courseId);
    completedLessons.assignAll(completed);
    _recalculateProgress();
  }

  void _recalculateProgress() {
    final total = course.value?.allLessons.length ?? 0;
    if (total == 0) return;
    progressPercent.value = (completedLessons.length / total) * 100;
  }

  bool isLessonCompleted(String lessonId) =>
      completedLessons.contains(lessonId);

  Future<void> onLessonCompleted(String lessonId) async {
    await _progressService.markLessonComplete(courseId, lessonId);
    completedLessons.add(lessonId);
    _recalculateProgress();
  }

  void toggleSection(String sectionId) {
    if (expandedSections.contains(sectionId)) {
      expandedSections.remove(sectionId);
    } else {
      expandedSections.add(sectionId);
    }
  }

  bool isSectionExpanded(String sectionId) =>
      expandedSections.contains(sectionId);

  void openLesson(LessonModel lesson) {
    Get.toNamed('/lesson-player', arguments: {
      'courseId': courseId,
      'lessonId': lesson.id,
      'allLessons': course.value?.allLessons ?? [],
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LessonController — player + navigation + marquage complétion
// ─────────────────────────────────────────────────────────────────────────────

class LessonController extends GetxController {
  final CoursService _coursService = CoursService();
  final ProgressService _progressService = ProgressService();

  final Rx<LessonModel?> lesson = Rx<LessonModel?>(null);
  final RxBool isLoading = true.obs;
  final RxInt currentIndex = 0.obs;
  final RxBool currentLessonCompleted = false.obs;

  String get courseId => Get.arguments['courseId'] as String;
  String get lessonId => Get.arguments['lessonId'] as String;
  List<LessonModel> get allLessons =>
      (Get.arguments['allLessons'] as List<LessonModel>?) ?? [];

  @override
  void onInit() {
    super.onInit();
    final idx = allLessons.indexWhere((l) => l.id == lessonId);
    currentIndex.value = idx >= 0 ? idx : 0;
    loadLesson();
  }

  Future<void> loadLesson() async {
    isLoading.value = true;
    try {
      final lid = allLessons[currentIndex.value].id;
      final result = await _coursService.fetchLesson(courseId, lid);
      lesson.value = result;
      currentLessonCompleted.value =
      await _progressService.isLessonComplete(courseId, lid);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger la leçon.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Marque manuellement la leçon courante comme terminée
  Future<void> markCurrentAsComplete() async {
    if (currentLessonCompleted.value) return;
    final lid = allLessons[currentIndex.value].id;
    await _progressService.markLessonComplete(courseId, lid);
    currentLessonCompleted.value = true;

    // Propager à CourseDetailController si en mémoire
    if (Get.isRegistered<CourseDetailController>()) {
      await Get.find<CourseDetailController>().onLessonCompleted(lid);
    }

    Get.snackbar(
      '✅ Leçon terminée',
      'Votre progression a été enregistrée.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Passe à la leçon suivante (marque auto comme complétée)
  Future<void> goToNext() async {
    await markCurrentAsComplete();
    if (hasNext) {
      currentIndex.value++;
      loadLesson();
    } else {
      Get.snackbar(
        '🎉 Félicitations !',
        'Vous avez terminé toutes les leçons de ce cours.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      Get.back();
    }
  }

  void goToPrevious() {
    if (hasPrevious) {
      currentIndex.value--;
      loadLesson();
    }
  }

  bool get hasPrevious => currentIndex.value > 0;
  bool get hasNext => currentIndex.value < allLessons.length - 1;
  int get totalLessons => allLessons.length;
  int get lessonNumber => currentIndex.value + 1;
}