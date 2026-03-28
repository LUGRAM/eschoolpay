// features/support/pages/privacy_policy_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF063D66),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -30, right: -30,
                    child: Container(
                      width: 140, height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, left: -20,
                    child: Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.privacy_tip_rounded,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Politique de confidentialité",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Dernière mise à jour : 26 mars 2026",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── CONTENU ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Intro
                  _IntroCard(),

                  const SizedBox(height: 16),

                  // Sections
                  _Section(
                    number: "1",
                    title: "Collecte des informations",
                    icon: Icons.folder_open_rounded,
                    content: [
                      _Paragraph(
                        "Nous collectons les informations que vous nous fournissez directement lors de l'utilisation de l'application E-SCHOOLPAY :",
                      ),
                      _BulletList(items: [
                        "Informations d'identification : nom, prénom, numéro de téléphone, adresse e-mail",
                        "Informations sur vos enfants : nom, prénom, date et lieu de naissance, photo, matricule scolaire",
                        "Informations de paiement : historique des transactions, méthodes de paiement utilisées",
                        "Données de connexion : token d'authentification, identifiant de session",
                      ]),
                      _Paragraph(
                        "Ces données sont collectées uniquement dans le but de vous fournir les services de paiement scolaire proposés par E-SCHOOLPAY.",
                      ),
                    ],
                  ),

                  _Section(
                    number: "2",
                    title: "Utilisation des données",
                    icon: Icons.settings_suggest_rounded,
                    content: [
                      _Paragraph("Vos données personnelles sont utilisées pour :"),
                      _BulletList(items: [
                        "Gérer votre compte et authentifier vos connexions",
                        "Traiter les paiements des frais scolaires (inscription, mensualités, cantine, transport)",
                        "Vous envoyer des confirmations et reçus de paiement",
                        "Améliorer nos services et l'expérience utilisateur",
                        "Respecter nos obligations légales et réglementaires",
                        "Vous contacter en cas de problème technique ou de sécurité",
                      ]),
                    ],
                  ),

                  _Section(
                    number: "3",
                    title: "Protection des données",
                    icon: Icons.shield_rounded,
                    content: [
                      _Paragraph(
                        "La sécurité de vos données est notre priorité. Nous mettons en œuvre les mesures suivantes :",
                      ),
                      _BulletList(items: [
                        "Chiffrement HTTPS/TLS pour toutes les communications",
                        "Authentification par token sécurisé (Passport OAuth2)",
                        "Stockage sécurisé des données sur des serveurs protégés",
                        "Accès limité aux données selon le principe du moindre privilège",
                        "Aucun stockage des informations bancaires ou codes PIN",
                      ]),
                      _Paragraph(
                        "Malgré ces mesures, aucun système n'est infaillible. Nous vous recommandons de ne jamais partager vos identifiants.",
                      ),
                    ],
                  ),

                  _Section(
                    number: "4",
                    title: "Partage des données",
                    icon: Icons.share_rounded,
                    content: [
                      _Paragraph(
                        "Nous ne vendons, n'échangeons ni ne transférons vos données personnelles à des tiers, sauf dans les cas suivants :",
                      ),
                      _BulletList(items: [
                        "Établissements scolaires partenaires, pour la gestion des inscriptions",
                        "Prestataires de paiement mobile (Airtel Money, Moov Money) pour traiter les transactions",
                        "Autorités légales ou réglementaires, si la loi l'exige",
                      ]),
                      _Paragraph(
                        "Tout partenaire ayant accès à vos données est soumis à des obligations strictes de confidentialité.",
                      ),
                    ],
                  ),

                  _Section(
                    number: "5",
                    title: "Données des enfants",
                    icon: Icons.child_care_rounded,
                    content: [
                      _Paragraph(
                        "E-SCHOOLPAY accorde une attention particulière à la protection des données relatives aux enfants :",
                      ),
                      _BulletList(items: [
                        "Les données des enfants ne sont accessibles qu'au parent ou tuteur légal titulaire du compte",
                        "Les photos des enfants sont stockées de manière sécurisée et non partagées publiquement",
                        "Aucune donnée d'enfant n'est utilisée à des fins commerciales ou publicitaires",
                        "Les données scolaires sont transmises uniquement aux établissements concernés",
                      ]),
                    ],
                  ),

                  _Section(
                    number: "6",
                    title: "Vos droits",
                    icon: Icons.gavel_rounded,
                    content: [
                      _Paragraph(
                        "Conformément aux lois en vigueur sur la protection des données, vous disposez des droits suivants :",
                      ),
                      _BulletList(items: [
                        "Droit d'accès : consulter vos données personnelles",
                        "Droit de rectification : corriger des informations inexactes",
                        "Droit à l'effacement : demander la suppression de vos données",
                        "Droit à la portabilité : recevoir vos données dans un format lisible",
                        "Droit d'opposition : refuser certains traitements de vos données",
                      ]),
                      _Paragraph(
                        "Pour exercer ces droits, contactez-nous à l'adresse indiquée en section 9.",
                      ),
                    ],
                  ),

                  _Section(
                    number: "7",
                    title: "Conservation des données",
                    icon: Icons.storage_rounded,
                    content: [
                      _Paragraph(
                        "Vos données sont conservées pendant toute la durée de votre utilisation de l'application, et au-delà selon les obligations légales :",
                      ),
                      _BulletList(items: [
                        "Données de compte : conservées jusqu'à la suppression du compte",
                        "Historique des paiements : 5 ans après la dernière transaction (obligations fiscales)",
                        "Données de connexion : 12 mois maximum",
                        "Photos de profil : supprimées lors de la suppression du compte",
                      ]),
                    ],
                  ),

                  _Section(
                    number: "8",
                    title: "Cookies et stockage local",
                    icon: Icons.storage_rounded,
                    content: [
                      _Paragraph(
                        "L'application utilise un stockage local sécurisé (GetStorage) pour conserver temporairement :",
                      ),
                      _BulletList(items: [
                        "Votre token d'authentification",
                        "Vos préférences (année scolaire sélectionnée)",
                        "Les informations de base de votre profil pour un chargement rapide",
                      ]),
                      _Paragraph(
                        "Ces données restent sur votre appareil et sont supprimées lors de la déconnexion.",
                      ),
                    ],
                  ),

                  _Section(
                    number: "9",
                    title: "Nous contacter",
                    icon: Icons.mail_rounded,
                    content: [
                      _Paragraph(
                        "Pour toute question relative à cette politique ou à vos données personnelles :",
                      ),
                      _ContactCard(),
                    ],
                  ),

                  _Section(
                    number: "10",
                    title: "Modifications",
                    icon: Icons.update_rounded,
                    content: [
                      _Paragraph(
                        "Nous nous réservons le droit de modifier cette politique à tout moment. En cas de changement significatif, vous serez notifié via l'application. La date de dernière mise à jour est indiquée en haut de cette page.",
                      ),
                      _Paragraph(
                        "En continuant à utiliser E-SCHOOLPAY après une modification, vous acceptez la nouvelle politique de confidentialité.",
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Footer
                  _FooterCard(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── WIDGETS COMPOSANTS ────────────────────────────────────────────

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF063D66).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF063D66).withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF063D66), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Bienvenue sur E-SCHOOLPAY. Cette politique décrit comment nous collectons, utilisons et protégeons vos informations personnelles. En utilisant notre application, vous acceptez les pratiques décrites ci-dessous.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;
  final List<Widget> content;

  const _Section({
    required this.number,
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: Colors.black.withValues(alpha: 0.06), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(icon, size: 18, color: const Color(0xFF063D66)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // Contenu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade700,
          height: 1.6,
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: items.map((item) => _BulletItem(item)).toList(),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          _ContactRow(
            icon: Icons.mail_rounded,
            label: "Email",
            value: "support@eschoolpay.ga",
          ),
          const Divider(height: 16),
          _ContactRow(
            icon: Icons.phone_rounded,
            label: "Téléphone",
            value: "+241 77 43 27 71",
          ),
          const Divider(height: 16),
          _ContactRow(
            icon: Icons.location_on_rounded,
            label: "Adresse",
            value: "PK9, Libreville, Gabon",
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF063D66).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: const Color(0xFF063D66)),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E))),
          ],
        ),
      ],
    );
  }
}

class _FooterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF063D66), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified_user_rounded,
              color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text(
            "Votre confiance est notre priorité",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "E-SCHOOLPAY s'engage à protéger vos données\npersonnelles et celles de vos enfants.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "J'ai compris",
                style: TextStyle(
                  color: Color(0xFF063D66),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}