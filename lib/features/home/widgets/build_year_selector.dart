import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/annee_scolaire_controller.dart';
import '../../../app/models/annee_scolaire.dart';

Widget buildYearSelector({
  EdgeInsetsGeometry? margin,
}) {
  const primaryBlue = Color(0xFF063D66);
  final controller = Get.find<AnneeScolaireController>();

  return Container(
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: primaryBlue,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: primaryBlue.withValues(alpha: 0.35),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Obx(() {
      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Chargement...",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );
      }

      final selected = controller.selectedYear.value;
      final normalizedSelected = selected == null
          ? null
          : controller.schoolYears.firstWhereOrNull((e) => e.id == selected.id);

      print("Affichage de l'annee scolaire: ${normalizedSelected?.id}");

      return Theme(
        // ✅ améliore le rendu menu (rayon, fond)
        data: Theme.of(Get.context!).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<AnneeScolaire>(
            isExpanded: true,
            value: normalizedSelected,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 28,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            menuMaxHeight: 320,
            // ✅ réduit la hauteur et évite un dropdown trop “gros”
            itemHeight: 56,
            // ✅ padding interne du bouton (partie bleue)
            alignment: Alignment.centerLeft,

            hint: const Text(
              "Année scolaire : —",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            // ✅ ITEMS DESIGNÉS
            items: controller.schoolYears.map((year) {
              final isSelected = normalizedSelected?.id == year.id;

              return DropdownMenuItem<AnneeScolaire>(
                value: year,
                child: _YearMenuItem(
                  label: year.annee_scolaire,
                  selected: isSelected,
                  // active: year.active, // si tu ajoutes ce champ plus tard
                ),
              );
            }).toList(),

            // ✅ PARTIE AFFICHÉE QUAND ON A SÉLECTIONNÉ
            selectedItemBuilder: (_) {
              return controller.schoolYears.map((year) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Année scolaire : ${year.annee_scolaire}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },

            onChanged: (value) async {
              if (value != null) {
                await controller.setSelectedYear(value);
              }
            },
          ),
        ),
      );
    }),
  );
}

/// ✅ Widget qui “design” chaque DropdownMenuItem
class _YearMenuItem extends StatelessWidget {
  final String label;
  final bool selected;

  /// Optionnel si tu ajoutes `active` dans ton modèle plus tard
  final bool? active;

  const _YearMenuItem({
    required this.label,
    required this.selected,
    this.active,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // ✅ Leading: icône / check
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: selected ? primaryBlue.withValues(alpha: 0.10) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected ? primaryBlue.withValues(alpha: 0.25) : Colors.grey.shade200,
              ),
            ),
            child: Icon(
              selected ? Icons.check_rounded : Icons.calendar_month_rounded,
              size: 16,
              color: selected ? primaryBlue : Colors.grey.shade600,
            ),
          ),

          const SizedBox(width: 12),

          // ✅ Label principal
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? primaryBlue : Colors.black87,
              ),
            ),
          ),

          // ✅ Tag optionnel “Active”
          if (active == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: primaryBlue.withValues(alpha: 0.18)),
              ),
              child: const Text(
                "Active",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}