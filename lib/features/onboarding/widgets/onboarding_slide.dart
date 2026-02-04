import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class OnboardingSlide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const OnboardingSlide({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 70),
        Icon(icon, size: 110, color: AppColors.primarySoft),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted, height: 1.4),
          ),
        ),
      ],
    );
  }
}
