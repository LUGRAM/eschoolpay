// features/support/pages/faq_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}
class _FAQPageState extends State<FAQPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _selectedCategory;

  static const _primaryBlue = Color(0xFF063D66);

  final List<_FAQCategory> _categories = [
    _FAQCategory(
      label: "Paiements",
      icon: Icons.payment_rounded,
      color: Color(0xFF1976D2),
      questions: [
        _FAQItem(
          question: "Quels modes de paiement sont acceptés ?",
          answer:
          "E-SCHOOLPAY accepte les paiements via Airtel Money (07x) et Moov Money (06x). Le paiement en espèces au guichet de l'école est également disponible avec confirmation manuelle.",
        ),
        _FAQItem(
          question: "Mon paiement a échoué mais j'ai été débité ?",
          answer:
          "Pas d'inquiétude. Le système de réconciliation automatique détecte les anomalies sous 24h. Conservez votre référence de transaction (ex : BANTU...) et contactez le support si le remboursement n'est pas effectué sous 48h.",
        ),
        _FAQItem(
          question: "Comment obtenir un reçu de paiement ?",
          answer:
          "Vos reçus sont disponibles dans l'onglet Historique. Appuyez sur une transaction pour afficher le détail complet avec la référence, le montant, la date et le statut.",
        ),
        _FAQItem(
          question: "Le paiement est-il sécurisé ?",
          answer:
          "Oui. Toutes les communications sont chiffrées (HTTPS/TLS). Nous ne stockons jamais vos codes PIN ou informations bancaires. Les transactions passent par les opérateurs officiels Airtel et Moov.",
        ),
      ],
    ),
    _FAQCategory(
      label: "Inscriptions",
      icon: Icons.school_rounded,
      color: Color(0xFF388E3C),
      questions: [
        _FAQItem(
          question: "Comment inscrire mon enfant ?",
          answer:
          "Allez dans Nos Services > Inscription. Sélectionnez l'enfant, l'établissement, le niveau et l'année scolaire. Confirmez les frais d'inscription et procédez au paiement.",
        ),
        _FAQItem(
          question: "Pourquoi je ne peux pas accéder aux autres services ?",
          answer:
          "Les services (frais scolaires, cantine, transport) nécessitent une inscription préalable. Inscrivez d'abord votre enfant via le menu Services > Inscription.",
        ),
        _FAQItem(
          question: "L'inscription est-elle immédiate ?",
          answer:
          "En cas de paiement Mobile Money confirmé, l'inscription est instantanée. Pour un paiement en espèces, elle sera activée après validation par l'administration de l'école.",
        ),
      ],
    ),
    _FAQCategory(
      label: "Mes enfants",
      icon: Icons.child_care_rounded,
      color: Color(0xFFE65100),
      questions: [
        _FAQItem(
          question: "Comment ajouter un enfant ?",
          answer:
          "Accédez à Mes enfants depuis l'accueil, puis appuyez sur Ajouter un enfant. Renseignez le prénom, nom, date de naissance, lieu de naissance et le sexe. Une photo est optionnelle.",
        ),
        _FAQItem(
          question: "Puis-je gérer plusieurs enfants ?",
          answer:
          "Oui, E-SCHOOLPAY permet de gérer plusieurs enfants depuis un seul compte parent. Chaque enfant a son propre profil, historique et suivi d'inscription.",
        ),
        _FAQItem(
          question: "Comment modifier la photo de mon enfant ?",
          answer:
          "Ouvrez le profil de l'enfant depuis Mes enfants, appuyez sur l'avatar. Choisissez entre Galerie ou Caméra. La photo sera automatiquement recadrée.",
        ),
      ],
    ),
    _FAQCategory(
      label: "Compte",
      icon: Icons.person_rounded,
      color: Color(0xFF6A1B9A),
      questions: [
        _FAQItem(
          question: "Comment modifier mes informations personnelles ?",
          answer:
          "Appuyez sur votre avatar en haut à droite de l'accueil. La page Modifier le profil vous permet de changer votre nom, email, téléphone et photo.",
        ),
        _FAQItem(
          question: "J'ai oublié mon mot de passe, que faire ?",
          answer:
          "Sur la page de connexion, appuyez sur 'Mot de passe oublié'. Entrez votre numéro de téléphone et suivez les instructions reçues par SMS.",
        ),
        _FAQItem(
          question: "Comment me déconnecter ?",
          answer:
          "Ouvrez le menu latéral (icône ☰ en haut à gauche) et appuyez sur Déconnexion. Confirmez dans la fenêtre qui apparaît.",
        ),
      ],
    ),
    _FAQCategory(
      label: "Technique",
      icon: Icons.settings_rounded,
      color: Color(0xFF00838F),
      questions: [
        _FAQItem(
          question: "L'application fonctionne-t-elle hors connexion ?",
          answer:
          "Certaines données sont mises en cache localement (profil, derniers paiements). Cependant, les paiements et mises à jour nécessitent une connexion Internet active.",
        ),
        _FAQItem(
          question: "Pourquoi l'historique est vide après reconnexion ?",
          answer:
          "L'historique se charge depuis notre serveur à chaque connexion. Si la liste reste vide, vérifiez votre connexion Internet et faites glisser vers le bas pour rafraîchir.",
        ),
      ],
    ),
  ];

  List<_FAQCategory> get _filtered {
    final q = _query.toLowerCase().trim();
    final cats = _selectedCategory != null
        ? [_categories[_selectedCategory!]]
        : _categories;

    if (q.isEmpty) return cats;

    return cats
        .map((cat) => _FAQCategory(
      label: cat.label,
      icon: cat.icon,
      color: cat.color,
      questions: cat.questions
          .where((item) =>
      item.question.toLowerCase().contains(q) ||
          item.answer.toLowerCase().contains(q))
          .toList(),
    ))
        .where((cat) => cat.questions.isNotEmpty)
        .toList();
  }

  int get _totalResults =>
      _filtered.fold(0, (sum, cat) => sum + cat.questions.length);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: CustomScrollView(
        slivers: [
          // ── HEADER ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 210,
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
                        colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                    bottom: 60, left: -20,
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 0, right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.quiz_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Questions fréquentes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Barre de recherche dans le header
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (v) =>
                                  setState(() => _query = v),
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: "Rechercher une question...",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13),
                                prefixIcon: Icon(Icons.search_rounded,
                                    color: Colors.grey.shade400),
                                suffixIcon: _query.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(Icons.close_rounded,
                                      color: Colors.grey.shade400,
                                      size: 18),
                                  onPressed: () => setState(() {
                                    _searchCtrl.clear();
                                    _query = '';
                                  }),
                                )
                                    : null,
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                              ),
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

          // ── FILTRES CATÉGORIE ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: "Toutes",
                      icon: Icons.list_rounded,
                      selected: _selectedCategory == null,
                      color: _primaryBlue,
                      onTap: () =>
                          setState(() => _selectedCategory = null),
                    ),
                    const SizedBox(width: 8),
                    ..._categories.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        label: e.value.label,
                        icon: e.value.icon,
                        selected: _selectedCategory == e.key,
                        color: e.value.color,
                        onTap: () => setState(() =>
                        _selectedCategory =
                        _selectedCategory == e.key
                            ? null
                            : e.key),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          // ── COMPTEUR ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                "$_totalResults question${_totalResults > 1 ? 's' : ''}",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // ── LISTE FAQ ─────────────────────────────────────────
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text("Aucune question trouvée",
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, catIndex) {
                  final cat = filtered[catIndex];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label catégorie
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 8, bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: cat.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(cat.icon,
                                    size: 14, color: cat.color),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cat.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: cat.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: cat.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${cat.questions.length}",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: cat.color),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Questions
                        ...cat.questions.map((item) => _FAQTile(
                          item: item,
                          accentColor: cat.color,
                        )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),

          // ── FOOTER contact ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.support_agent_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vous n'avez pas trouvé ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            "Contactez notre support",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Aide",
                          style: TextStyle(
                            color: Color(0xFF063D66),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── MODELS ───────────────────────────────────────────────────────

class _FAQCategory {
  final String label;
  final IconData icon;
  final Color color;
  final List<_FAQItem> questions;

  const _FAQCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class _FAQItem {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});
}

// ── WIDGETS ──────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : Colors.black.withValues(alpha: 0.08)),
          boxShadow: selected
              ? [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 13,
                color: selected ? Colors.white : Colors.grey.shade500),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQTile extends StatelessWidget {
  final _FAQItem item;
  final Color accentColor;

  const _FAQTile({required this.item, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: accentColor,
          collapsedIconColor: Colors.grey.shade400,
          tilePadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          title: Text(
            item.question,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xFF1A1A2E),
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: accentColor.withValues(alpha: 0.12)),
              ),
              child: Text(
                item.answer,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}