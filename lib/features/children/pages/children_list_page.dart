import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/page_scaffold.dart';
import '../controllers/children_controller.dart';

class ChildrenListPage extends StatelessWidget {
  const ChildrenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChildrenController>();

    return PageScaffold(
      title: "Mes enfants",
      child: Obx(() {

        if (c.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (c.children.isEmpty) {
          return _EmptyState(onAdd: () => Get.toNamed(Routes.addChild));
        }

        return RefreshIndicator(
          onRefresh: c.fetchChildren,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: c.children.length,
            itemBuilder: (_, i) {
              final child = c.children[i];
              return _ChildCard(child: child);
            },
          ),
        );
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.child_care_rounded,
            size: 90,
            color: AppColors.primarySoft.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            "Aucun enfant enregistré",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Ajoutez votre premier enfant pour commencer",
            style: TextStyle(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text("Ajouter un enfant"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySoft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final dynamic child;

  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primarySoft.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          /// Avatar dynamique avec initiales
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              child.firstName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.fullName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      child.sexe == "M" ? Icons.male : Icons.female,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      child.sexe == "M" ? "Garçon" : "Fille",
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Historique
          IconButton(
            onPressed: () => Get.toNamed(
              Routes.childPaymentHistory,
              arguments: child,
            ),
            icon: const Icon(Icons.receipt_long_rounded),
          ),
        ],
      ),
    );
  }
}