import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NetworkErrorContent extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final bool showClose;
  final VoidCallback? onClose;

  const NetworkErrorContent({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.showClose = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 44,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPast,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryPast,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Réessayer",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          if (showClose) ...[
            const SizedBox(height: 6),
            TextButton(
              onPressed: onClose,
              child: Text(
                "Fermer",
                style: TextStyle(color: AppColors.primaryPast),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
