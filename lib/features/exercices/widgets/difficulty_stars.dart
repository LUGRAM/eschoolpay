import 'package:flutter/material.dart';

class DifficultyStars extends StatelessWidget {
  final String difficulty;
  final double size;

  const DifficultyStars({
    super.key,
    required this.difficulty,
    this.size = 12,
  });

  int get _level {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return 1;
      case 'difficile':
        return 3;
      default:
        return 2;
    }
  }

  Color get _color {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return const Color(0xFF4CAF50);
      case 'difficile':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFFF57C00);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            Icons.circle,
            size: size,
            color: i < _level ? _color : _color.withValues(alpha: 0.18),
          ),
        );
      }),
    );
  }
}
