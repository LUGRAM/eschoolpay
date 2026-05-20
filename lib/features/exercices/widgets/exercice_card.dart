import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../models/exercice_model.dart';
import 'difficulty_stars.dart';

// StatefulWidget requis pour le press-scale (AnimatedScale nécessite un état)
class ExerciceCard extends StatefulWidget {
  final ExerciceModel exercice;
  final VoidCallback onTap;

  const ExerciceCard({
    super.key,
    required this.exercice,
    required this.onTap,
  });

  @override
  State<ExerciceCard> createState() => _ExerciceCardState();
}

class _ExerciceCardState extends State<ExerciceCard> {
  bool _pressed = false;

  Color get _subjectColor {
    switch (widget.exercice.subject.toLowerCase()) {
      case 'mathématiques':
        return const Color(0xFF1976D2);
      case 'français':
        return const Color(0xFF7B1FA2);
      case 'sciences':
        return const Color(0xFF388E3C);
      case 'histoire':
        return const Color(0xFFF57C00);
      case 'géographie':
        return const Color(0xFF0097A7);
      default:
        return AppColors.primary;
    }
  }

  IconData get _subjectIcon {
    switch (widget.exercice.subject.toLowerCase()) {
      case 'mathématiques':
        return Icons.calculate_outlined;
      case 'français':
        return Icons.menu_book_outlined;
      case 'sciences':
        return Icons.science_outlined;
      case 'histoire':
        return Icons.history_edu_outlined;
      case 'géographie':
        return Icons.public_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        scale: _pressed ? 0.96 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            // Claymorphism : double shadow (profondeur + halo couleur)
            boxShadow: [
              BoxShadow(
                color: _subjectColor.withValues(alpha: 0.13),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: _subjectColor.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_subjectColor, _subjectColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -8,
            child: Icon(
              _subjectIcon,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_subjectIcon, color: Colors.white, size: 22),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.exercice.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.exercice.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.exercice.level,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              DifficultyStars(
                  difficulty: widget.exercice.difficulty, size: 10),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.quiz_outlined,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '${widget.exercice.questionCount} questions',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
