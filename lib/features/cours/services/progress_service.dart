import 'package:shared_preferences/shared_preferences.dart';

/// Gère la persistance locale de la progression des cours.
/// Clé de stockage : "progress_{courseId}" → Set de lessonIds complétées
class ProgressService {
  static const _prefix = 'progress_';

  // ── Marquer une leçon comme terminée ───────────────────────────────────────
  Future<void> markLessonComplete(String courseId, String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(courseId);
    final completed = prefs.getStringList(key) ?? [];
    if (!completed.contains(lessonId)) {
      completed.add(lessonId);
      await prefs.setStringList(key, completed);
    }
  }

  // ── Récupérer les leçons complétées d'un cours ─────────────────────────────
  Future<Set<String>> getCompletedLessons(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key(courseId)) ?? []).toSet();
  }

  // ── Vérifier si une leçon est complétée ────────────────────────────────────
  Future<bool> isLessonComplete(String courseId, String lessonId) async {
    final completed = await getCompletedLessons(courseId);
    return completed.contains(lessonId);
  }

  // ── Calculer le % de progression d'un cours ───────────────────────────────
  Future<double> getCourseProgress(
      String courseId, int totalLessons) async {
    if (totalLessons == 0) return 0.0;
    final completed = await getCompletedLessons(courseId);
    return (completed.length / totalLessons) * 100;
  }

  // ── Réinitialiser un cours ─────────────────────────────────────────────────
  Future<void> resetCourse(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(courseId));
  }

  String _key(String courseId) => '$_prefix$courseId';
}