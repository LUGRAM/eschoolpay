import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CorrectionPanel extends StatelessWidget {
  final bool isVisible;
  final bool isCorrect;
  final String correctAnswer;
  final String explanation;

  const CorrectionPanel({
    super.key,
    required this.isVisible,
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
  });

  static const _green = Color(0xFF4CAF50);
  static const _red = Color(0xFFE53935);
  static const _amber = Color(0xFFF57C00);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      child: isVisible ? _buildPanel() : const SizedBox.shrink(),
    );
  }

  Widget _buildPanel() {
    final color = isCorrect ? _green : _red;
    final bgColor =
        isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    final icon =
        isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final label = isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (!isCorrect && correctAnswer.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Bonne réponse : $correctAnswer',
              style: TextStyle(
                color: color.withValues(alpha: 0.85),
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: _amber, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    explanation,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
