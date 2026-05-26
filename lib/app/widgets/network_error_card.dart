import 'package:flutter/material.dart';

import 'network_error_content.dart';

class NetworkErrorCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorCard({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: NetworkErrorContent(
          title: title,
          message: message,
          onRetry: onRetry,
        ),
      ),
    );
  }
}
