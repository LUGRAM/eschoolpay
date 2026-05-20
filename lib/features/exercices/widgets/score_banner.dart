import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class ScoreBanner extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const ScoreBanner({
    super.key,
    required this.score,
    required this.total,
    required this.onRetry,
    required this.onExit,
  });

  double get _percent => total == 0 ? 0 : score / total;

  Color get _scoreColor {
    if (_percent >= 0.8) return const Color(0xFF4CAF50);
    if (_percent >= 0.5) return const Color(0xFFF57C00);
    return const Color(0xFFE53935);
  }

  String get _message {
    if (_percent >= 0.8) return 'Excellent travail !';
    if (_percent >= 0.5) return 'Bien joué ! Continuez ainsi.';
    return 'Bon courage ! Réessayez pour progresser.';
  }

  // Icône Material au lieu d'emoji (règle no-emoji-icons)
  IconData get _trophyIcon {
    if (_percent >= 0.8) return Icons.emoji_events_rounded;
    if (_percent >= 0.5) return Icons.thumb_up_rounded;
    return Icons.fitness_center_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _scoreColor.withValues(alpha: 0.15),
                blurRadius: 40,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône Material (pas d'emoji)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _scoreColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_trophyIcon, color: _scoreColor, size: 30),
              ),
              const SizedBox(height: 16),
              // Score circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _scoreColor, width: 4),
                  color: _scoreColor.withValues(alpha: 0.07),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score/$total',
                        style: TextStyle(
                          color: _scoreColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${(_percent * 100).toInt()}%',
                        style: TextStyle(
                          color: _scoreColor.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Vous avez répondu correctement à $score question${score > 1 ? 's' : ''} sur $total.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _percent,
                  backgroundColor: _scoreColor.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: _scoreColor),
                        foregroundColor: _scoreColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onExit,
                      icon: const Icon(Icons.home_outlined,
                          color: Colors.white),
                      label: const Text(
                        'Terminer',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
