import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/exercices_controller.dart';
import '../models/question_model.dart';
import '../widgets/correction_panel.dart';
import '../widgets/question_enonce_card.dart';
import '../widgets/question_option_tile.dart';
import '../widgets/score_banner.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(QuestionController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _confirmExit(ctrl),
        ),
        // exerciceTitle est statique (Get.arguments) → pas de Obx
        title: Text(
          ctrl.exerciceTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          // Zone A — lit progressValue → currentIndex.value ✓
          child: Obx(() {
            final reduce = MediaQuery.of(context).disableAnimations;
            return LinearProgressIndicator(
              value: ctrl.progressValue,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                reduce ? Colors.white.withValues(alpha: 0.6) : Colors.white,
              ),
              minHeight: 4,
            );
          }),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zone B — énoncé : lit currentIndex.value ✓
                  Obx(() => QuestionEnonceCard(
                        questionNumber: ctrl.currentIndex.value + 1,
                        totalQuestions: ctrl.totalQuestions,
                        statement: ctrl.currentQuestion.statement,
                      )),
                  const SizedBox(height: 20),

                  // Zone C — options/saisie : lit currentIndex + isAnswered + selectedAnswer + correctAnswer ✓
                  Obx(() {
                    final q = ctrl.currentQuestion; // → currentIndex.value ✓
                    if (q.isQcm) return _buildQcmOptions(ctrl, q);
                    return _buildTextInput(ctrl);
                  }),
                  const SizedBox(height: 16),

                  // Zone D — correction : lit isAnswered + isCorrect + correctAnswer + explanation ✓
                  Obx(() => CorrectionPanel(
                        isVisible: ctrl.isAnswered.value,
                        isCorrect: ctrl.isCorrect.value,
                        correctAnswer: ctrl.correctAnswer.value,
                        explanation: ctrl.explanation.value,
                      )),
                  const SizedBox(height: 16),

                  // Zone E — boutons : lit isAnswered + isVerifying + isLastQuestion(→currentIndex) ✓
                  Obx(() {
                    if (!ctrl.isAnswered.value) {
                      return _buildSubmitButton(ctrl);
                    }
                    return _buildNextButton(ctrl);
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Zone F — score overlay : lit isQuizFinished + score ✓
          Obx(() {
            final reduce = MediaQuery.of(context).disableAnimations;
            return AnimatedSwitcher(
              duration: Duration(milliseconds: reduce ? 0 : 280),
              child: ctrl.isQuizFinished.value
                  ? ScoreBanner(
                      key: const ValueKey('score'),
                      score: ctrl.score.value,
                      total: ctrl.totalQuestions,
                      onRetry: ctrl.retryQuiz,
                      onExit: () => Get.back(),
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }

  // Appelé dans Zone C (Obx) → isAnswered.value, correctAnswer.value, selectedAnswer.value tracés ✓
  Widget _buildQcmOptions(QuestionController ctrl, QuestionModel q) {
    const letters = ['A', 'B', 'C', 'D'];
    final options = q.options ?? [];
    return Column(
      children: options.asMap().entries.map((entry) {
        final i = entry.key;
        final opt = entry.value;
        OptionState state = OptionState.normal;
        if (ctrl.isAnswered.value) {
          if (opt == ctrl.correctAnswer.value) {
            state = OptionState.correct;
          } else if (opt == ctrl.selectedAnswer.value) {
            state = OptionState.wrong;
          }
        } else if (opt == ctrl.selectedAnswer.value) {
          state = OptionState.selected;
        }
        return QuestionOptionTile(
          key: ValueKey('opt_$i'),
          letter: i < letters.length ? letters[i] : '${i + 1}',
          text: opt,
          state: state,
          onTap: ctrl.isAnswered.value
              ? null
              : () => ctrl.selectedAnswer.value = opt,
        );
      }).toList(),
    );
  }

  // Appelé dans Zone C (Obx) → isAnswered.value tracé par le Obx parent ✓
  Widget _buildTextInput(QuestionController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: ctrl.textController,
        enabled: !ctrl.isAnswered.value,
        maxLines: 3,
        minLines: 1,
        decoration: const InputDecoration(
          hintText: 'Tapez votre réponse ici…',
          hintStyle: TextStyle(color: AppColors.textMuted),
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
      ),
    );
  }

  // Appelé dans Zone E (Obx) → isVerifying.value tracé par le Obx parent ✓
  Widget _buildSubmitButton(QuestionController ctrl) {
    return Semantics(
      button: true,
      label: ctrl.isVerifying.value
          ? 'Vérification en cours'
          : 'Valider la réponse',
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: ctrl.isVerifying.value ? null : ctrl.submitAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.border,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: ctrl.isVerifying.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Valider la réponse',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
        ),
      ),
    );
  }

  // Appelé dans Zone E (Obx) → isLastQuestion(→currentIndex.value) tracé par le Obx parent ✓
  Widget _buildNextButton(QuestionController ctrl) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: ctrl.nextQuestion,
        icon: Icon(
          ctrl.isLastQuestion
              ? Icons.emoji_events_outlined
              : Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
        label: Text(
          ctrl.isLastQuestion ? 'Voir les résultats' : 'Question suivante',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientEnd,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _confirmExit(QuestionController ctrl) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Quitter l\'exercice ?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Votre progression sera perdue si vous quittez maintenant.',
          style: TextStyle(color: AppColors.textMuted, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continuer'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Quitter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
