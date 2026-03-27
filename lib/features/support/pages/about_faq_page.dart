// features/support/pages/about_faq_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'faq_page.dart';
import 'privacy_policy_page.dart';

class AboutFaqPage extends StatelessWidget {
  const AboutFaqPage({super.key});

  static const _primaryBlue = Color(0xFF063D66);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _primaryBlue,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF063D66), Color(0xFF1565C0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40, right: -40,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40, left: -20,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  // Logo + titre
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo app
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: const Icon(Icons.school_rounded,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "E-SCHOOLPAY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Paiements scolaires simplifiés au Gabon",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.80),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Badge version
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Version 1.0.0 • Libreville, Gabon",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
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

                  // ── Mission ─────────────────────────────────
                  _InfoCard(
                    title: "Notre Mission",
                    icon: Icons.flag_rounded,
                    color: _primaryBlue,
                    child: const Text(
                      "E-SCHOOLPAY simplifie le paiement des frais scolaires pour les parents gabonais. Notre plateforme connecte les familles aux établissements scolaires pour une gestion transparente et sécurisée des inscriptions, mensualités, cantine et transport.",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555566),
                          height: 1.7),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Services proposés ────────────────────────
                  _SectionTitle("Services disponibles"),
                  const SizedBox(height: 10),

                  _ServicesList(),

                  const SizedBox(height: 20),

                  // ── Paiements acceptés ───────────────────────
                  _SectionTitle("Modes de paiement"),
                  const SizedBox(height: 10),

                  _PaymentMethodsCard(),

                  const SizedBox(height: 20),

                  // ── Liens rapides ────────────────────────────
                  _SectionTitle("Informations légales"),
                  const SizedBox(height: 10),

                  _QuickLinkTile(
                    icon: Icons.privacy_tip_rounded,
                    title: "Politique de confidentialité",
                    subtitle: "Comment nous protégeons vos données",
                    color: _primaryBlue,
                    onTap: () => Get.to(() => const PrivacyPolicyPage()),
                  ),
                  const SizedBox(height: 10),
                  _QuickLinkTile(
                    icon: Icons.quiz_rounded,
                    title: "Questions fréquentes",
                    subtitle: "Réponses aux questions courantes",
                    color: const Color(0xFF1976D2),
                    onTap: () => Get.to(() => const FAQPage()),
                  ),
                  const SizedBox(height: 10),
                  _QuickLinkTile(
                    icon: Icons.share_rounded,
                    title: "Partager l'application",
                    subtitle: "Invitez d'autres parents",
                    color: const Color(0xFF388E3C),
                    onTap: () async {
                      await Share.share(
                        "Télécharge E-SCHOOLPAY pour payer les frais scolaires en un clic ! https://eschoolpay.ga",
                        subject: "Paiement scolaire simplifié",
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── Contact ──────────────────────────────────
                  _SectionTitle("Nous contacter"),
                  const SizedBox(height: 10),

                  _ContactCard(),

                  const SizedBox(height: 20),

                  // ── Footer ───────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "© 2026 E-SCHOOLPAY · IT-MASTER AFRICA",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "PK9, Libreville · Gabon",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),

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

// ── WIDGETS ──────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border:
        Border.all(color: Colors.black.withValues(alpha: 0.06)),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E))),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ServicesList extends StatelessWidget {
  final _services = const [
    (Icons.how_to_reg_rounded, "Inscription scolaire", Color(0xFF063D66)),
    (Icons.receipt_long_rounded, "Frais de scolarité", Colors.orange),
    (Icons.restaurant_rounded, "Cantine scolaire", Colors.green),
    (Icons.directions_bus_rounded, "Transport scolaire", Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: _services.asMap().entries.map((e) {
          final isLast = e.key == _services.length - 1;
          final (icon, label, color) = e.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 13),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 16, color: color),
                    ),
                    const SizedBox(width: 12),
                    Text(label,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E))),
                    const Spacer(),
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: color),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black.withValues(alpha: 0.04)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          _PaymentBadge(
            label: "Airtel Money",
            icon: Icons.phone_android_rounded,
            color: const Color(0xFFE53935),
          ),
          const SizedBox(width: 10),
          _PaymentBadge(
            label: "Moov Money",
            icon: Icons.phone_iphone_rounded,
            color: const Color(0xFF1976D2),
          ),
          const SizedBox(width: 10),
          _PaymentBadge(
            label: "Espèces",
            icon: Icons.money_rounded,
            color: const Color(0xFF388E3C),
          ),
        ],
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _PaymentBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
          Border.all(color: Colors.black.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E))),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade300, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          _ContactRow(
              icon: Icons.mail_rounded,
              color: const Color(0xFF063D66),
              label: "Email",
              value: "support@eschoolpay.ga"),
          const Divider(height: 16),
          _ContactRow(
              icon: Icons.phone_rounded,
              color: const Color(0xFF388E3C),
              label: "Téléphone",
              value: "+241 77 43 27 71"),
          const Divider(height: 16),
          _ContactRow(
              icon: Icons.language_rounded,
              color: const Color(0xFF1976D2),
              label: "Site web",
              value: "eschoolpay.ga"),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 12),
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