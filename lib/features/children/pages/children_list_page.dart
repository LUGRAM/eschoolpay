import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/page_scaffold.dart';
import '../../../app/widgets/gradient_button.dart';
import '../controllers/children_controller.dart';
import 'child_detail_page.dart';

class ChildrenListPage extends StatelessWidget {
  const ChildrenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChildrenController>();

    return PageScaffold(
      title: "Mes enfants",
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.children.isEmpty) {
          return _EmptyState(onAdd: () => Get.toNamed(Routes.addChild));
        }

        // Utilisation d'un Stack pour superposer le bouton en bas de l'écran
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: c.fetchChildren,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // Padding bas pour ne pas cacher le dernier enfant
                itemCount: c.children.length,
                itemBuilder: (_, i) => _ChildCard(child: c.children[i]),
              ),
            ),

            // Ton GradientButton positionné en bas
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: GradientButton(
                label: "Ajouter un enfant",
                onTap: () => Get.toNamed(Routes.addChild),
                loading: false, // Tu peux lier ça à un c.isAdding si besoin
              ),
            ),
          ],
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
            icon: const Icon(Icons.add, color: Colors.white,),
            label: const Text("Ajouter un enfant", style: TextStyle(color: Colors.white),),
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

// ─── Dans children_list_page.dart ────────────────────────────────
// Ajoute l'import en haut du fichier :
// import '../../children/pages/child_detail_page.dart';
// ou via la route si tu préfères (voir note ci-dessous)

class _ChildCard extends StatelessWidget {
  final dynamic child;

  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Tap sur la carte → détail de l'enfant
      onTap: () => Get.to(
            () => const ChildDetailPage(),
        arguments: child,
        transition: Transition.cupertino,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              AppColors.primarySoft.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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

            // ✅ Flèche indicateur de navigation (remplace le bouton historique)
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/*
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

 */