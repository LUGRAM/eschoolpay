import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF063D66);

    // Structure de données pour la FAQ
    final List<Map<String, dynamic>> faqData = [
      {
        "category": "Paiements",
        "questions": [
          {
            "q": "Quels sont les modes de paiement acceptés ?",
            "a": "Vous pouvez payer via Airtel Money, Moov Money ou en utilisant le solde de votre portefeuille E-SCHOOLPAY."
          },
          {
            "q": "Mon paiement a échoué mais j'ai été débité ?",
            "a": "Pas d'inquiétude. Notre système de réconciliation automatique détecte les erreurs sous 24h. Vous pouvez aussi contacter le support via l'onglet 'Aide' avec votre référence de transaction."
          },
        ]
      },
      {
        "category": "Inscriptions & Enfants",
        "questions": [
          {
            "q": "Comment ajouter un deuxième enfant ?",
            "a": "Allez dans 'Mes enfants' depuis l'accueil, puis cliquez sur le bouton '+' en bas à droite pour remplir les informations du nouvel enfant."
          },
          {
            "q": "Où trouver mon reçu de paiement ?",
            "a": "Une fois le paiement validé, le reçu est disponible dans l'onglet 'Historique'. Vous pouvez le visualiser ou le télécharger au format PDF."
          },
        ]
      },
      {
        "category": "Sécurité",
        "questions": [
          {
            "q": "Mes informations sont-elles protégées ?",
            "a": "Oui, E-SCHOOLPAY utilise un cryptage SSL de bout en bout. Nous ne stockons jamais vos codes secrets Mobile Money."
          },
        ]
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text("Foire Aux Questions",
            style: TextStyle(color: Color(0xFF063D66), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF063D66)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqData.length,
        itemBuilder: (context, index) {
          final category = faqData[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Text(
                  category['category'],
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ...category['questions'].map<Widget>((item) {
                return _buildFAQTile(item['q'], item['a'], primaryBlue);
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // Enlève les lignes de division natives du ExpansionTile
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: primaryColor,
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}