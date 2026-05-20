import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

enum OptionState { normal, selected, correct, wrong }

class QuestionOptionTile extends StatelessWidget {
  final String letter;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const QuestionOptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    this.onTap,
  });

  static const _green = Color(0xFF4CAF50);
  static const _red = Color(0xFFE53935);

  Color get _bgColor {
    switch (state) {
      case OptionState.selected:
        return AppColors.primary.withValues(alpha: 0.07);
      case OptionState.correct:
        return _green.withValues(alpha: 0.1);
      case OptionState.wrong:
        return _red.withValues(alpha: 0.1);
      default:
        return Colors.white;
    }
  }

  Color get _borderColor {
    switch (state) {
      case OptionState.selected:
        return AppColors.primary;
      case OptionState.correct:
        return _green;
      case OptionState.wrong:
        return _red;
      default:
        return AppColors.border;
    }
  }

  Color get _letterBg {
    switch (state) {
      case OptionState.selected:
        return AppColors.primary;
      case OptionState.correct:
        return _green;
      case OptionState.wrong:
        return _red;
      default:
        return AppColors.background;
    }
  }

  Color get _letterColor {
    return state == OptionState.normal ? AppColors.textMuted : Colors.white;
  }

  Widget get _trailing {
    switch (state) {
      case OptionState.correct:
        return const Icon(Icons.check_circle, color: _green, size: 20);
      case OptionState.wrong:
        return const Icon(Icons.cancel, color: _red, size: 20);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _letterBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: _letterColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: state == OptionState.normal
                      ? FontWeight.w400
                      : FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _trailing,
          ],
        ),
      ),
    );
  }
}
