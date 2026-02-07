// features/home/widgets/children_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../children/controllers/children_controller.dart';
import '../../children/pages/add_child_page.dart';

class ChildrenCard extends StatelessWidget {
  final Color primaryBlue = const Color(0xFF063D66);

  const ChildrenCard({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère l'instance du controller (déjà initialisée par GetX)
    final childrenCtrl = Get.find<ChildrenController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryBlue.withValues(alpha:0.1),
                  child: Icon(Icons.child_care_rounded, color: primaryBlue),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    "Mes enfants",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // --- LISTE DYNAMIQUE DES ENFANTS ---
          Obx(() {
            if (childrenCtrl.children.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Aucun enfant enregistré",
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
              );
            }

            return SizedBox(
              height: 90,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: childrenCtrl.children.length,
                itemBuilder: (context, index) {
                  final child = childrenCtrl.children[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: primaryBlue.withValues(alpha:0.1),
                          child: Text(
                            child.fullName.substring(0, 1).toUpperCase(),
                            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          child.fullName.split(' ')[0], // Affiche juste le prénom
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),

          const Divider(height: 1),

          // Bouton d'ajout
          InkWell(
            onTap: () => Get.to(() => const AddChildPage()),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Ajouter un enfant",
                    style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}