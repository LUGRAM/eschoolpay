import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/exercice_model.dart';
import '../models/question_model.dart';
import '../services/exercices_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ExercicesController — liste & filtres
// ─────────────────────────────────────────────────────────────────────────────

class ExercicesController extends GetxController {
  final _service = ExercicesService();

  final RxList<ExerciceModel> exercices = <ExerciceModel>[].obs;
  final List<ExerciceModel> _all = [];
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedMatiere = ''.obs;
  final RxList<String> matieres = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadExercices();
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 400),
    );
  }

  Future<void> loadExercices() async {
    isLoading.value = true;
    try {
      final result = await _service.fetchExercices();
      _all
        ..clear()
        ..addAll(result);
      final subjects = result.map((e) => e.subject).toSet().toList()..sort();
      matieres.assignAll(subjects);
      _applyFilters();
    } catch (_) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les exercices.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var filtered = _all.toList();
    final q = searchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.subject.toLowerCase().contains(q) ||
              e.level.toLowerCase().contains(q))
          .toList();
    }
    if (selectedMatiere.value.isNotEmpty) {
      filtered =
          filtered.where((e) => e.subject == selectedMatiere.value).toList();
    }
    exercices.assignAll(filtered);
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void filterByMatiere(String matiere) {
    selectedMatiere.value =
        selectedMatiere.value == matiere ? '' : matiere;
    _applyFilters();
  }

  @override
  void refresh() => loadExercices();
}

// ─────────────────────────────────────────────────────────────────────────────
// ExerciceDetailController
// ─────────────────────────────────────────────────────────────────────────────

class ExerciceDetailController extends GetxController {
  final _service = ExercicesService();

  final Rx<ExerciceModel?> exercice = Rx<ExerciceModel?>(null);
  final RxBool isLoading = true.obs;

  String get exerciceId =>
      (Get.arguments?['exerciceId'] as String?) ?? '';

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      exercice.value = await _service.fetchExerciceDetail(exerciceId);
    } catch (_) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger cet exercice.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QuestionController — navigation questions + scoring
// ─────────────────────────────────────────────────────────────────────────────

class QuestionController extends GetxController {
  final _service = ExercicesService();
  final textController = TextEditingController();

  final RxInt currentIndex = 0.obs;
  final RxString selectedAnswer = ''.obs;
  final RxBool isAnswered = false.obs;
  final RxBool isCorrect = false.obs;
  final RxString correctAnswer = ''.obs;
  final RxString explanation = ''.obs;
  final RxInt score = 0.obs;
  final RxBool isQuizFinished = false.obs;
  final RxBool isVerifying = false.obs;

  String get exerciceId =>
      (Get.arguments?['exerciceId'] as String?) ?? '';
  String get exerciceTitle =>
      (Get.arguments?['exerciceTitle'] as String?) ?? 'Exercice';
  List<QuestionModel> get questions =>
      (Get.arguments?['questions'] as List<QuestionModel>?) ?? [];

  QuestionModel get currentQuestion => questions[currentIndex.value];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;
  double get progressValue =>
      totalQuestions == 0 ? 0 : (currentIndex.value + 1) / totalQuestions;

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> submitAnswer() async {
    if (isAnswered.value || isVerifying.value) return;
    final answer = currentQuestion.isQcm
        ? selectedAnswer.value
        : textController.text.trim();
    if (answer.isEmpty) {
      Get.snackbar(
        'Attention',
        'Veuillez répondre avant de valider.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isVerifying.value = true;
    try {
      final result = await _service.verifierReponse(
        exerciceId: exerciceId,
        questionId: currentQuestion.id,
        reponse: answer,
      );
      isCorrect.value = result['correct'] as bool;
      correctAnswer.value = result['correct_answer'] as String? ?? '';
      explanation.value = result['explanation'] as String? ?? '';
      if (isCorrect.value) score.value++;
      isAnswered.value = true;
    } catch (_) {
      Get.snackbar(
        'Erreur',
        'Vérification impossible.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  void nextQuestion() {
    if (isLastQuestion) {
      isQuizFinished.value = true;
    } else {
      currentIndex.value++;
      _reset();
    }
  }

  void _reset() {
    selectedAnswer.value = '';
    textController.clear();
    isAnswered.value = false;
    isCorrect.value = false;
    correctAnswer.value = '';
    explanation.value = '';
  }

  void retryQuiz() {
    currentIndex.value = 0;
    score.value = 0;
    isQuizFinished.value = false;
    _reset();
  }
}
