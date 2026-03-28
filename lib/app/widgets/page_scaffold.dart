import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showHelp;

  const PageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showHelp = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          if (showHelp)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () {},
                child: const Text('Besoin d’aide?'),
              ),
            )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
