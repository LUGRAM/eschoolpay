import 'package:flutter/material.dart';

class AboutFaqPage extends StatelessWidget {
  const AboutFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF063D66);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(title: const Text("Comprendre la FAQ"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- 1. LE CONCEPT (Le "Quoi") ---
            _buildPinterestCard(
              icon: Icons.lightbulb_outline_rounded,
              iconColor: Colors.orange,
              title: "Le Concept",
              content: "Un espace regroupant les interrogations fréquentes. Au lieu d'appeler l'école, trouvez la solution en un clic.",
            ),

            const SizedBox(height: 20),

            // --- 2. LES OBJECTIFS (Le "Pourquoi") ---
            _buildPinterestCard(
              icon: Icons.track_changes_rounded,
              iconColor: Colors.redAccent,
              title: "Les Objectifs",
              child: Column(
                children: [
                  _buildMiniStep(Icons.accessibility_new, "Autonomie", "Réglez vos problèmes seul."),
                  _buildMiniStep(Icons.timer_outlined, "Gain de temps", "Moins d'appels au support."),
                  _buildMiniStep(Icons.verified_user_outlined, "Confiance", "Une app sérieuse et proactive."),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. LA STRUCTURE (Le "Comment") ---
            _buildPinterestCard(
              icon: Icons.layers_outlined,
              iconColor: primaryBlue,
              title: "Structure Technique",
              content: "Organisation par Catégories, Questions directes et Réponses pédagogiques via ExpansionTile.",
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET DE CARTE STYLE PINTEREST ---
  Widget _buildPinterestCard({required IconData icon, required Color iconColor, required String title, String? content, Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Très arrondi
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (content != null) ...[
            const SizedBox(height: 10),
            Text(content, style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
          ],
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildMiniStep(IconData icon, String t, String st) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text.rich(TextSpan(text: "$t : ", style: const TextStyle(fontWeight: FontWeight.bold), children: [TextSpan(text: st, style: const TextStyle(fontWeight: FontWeight.normal))]))),
        ],
      ),
    );
  }
}