// features/history/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/router/routes.dart';
import '../controllers/payment_history_controller.dart';
import '../models/payment_history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _searchCtrl = TextEditingController();
  final _searchQuery = ''.obs;
  PaymentServiceType? _activeFilter; // null = tous

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Filtre combiné : texte + type ──────────────────────────
  List<PaymentHistory> _filtered(List<PaymentHistory> all) {
    final q = _searchQuery.value.toLowerCase().trim();

    return all.where((h) {
      // Filtre type actif
      if (_activeFilter != null && h.service != _activeFilter) return false;

      // Filtre texte vide → tout passe
      if (q.isEmpty) return true;

      // Recherche par nom enfant
      if (h.childName.toLowerCase().contains(q)) return true;

      // Recherche par référence (id)
      if (h.id.toLowerCase().contains(q)) return true;
      if ('ref-${h.id}'.contains(q)) return true;

      // Recherche par type de service (label)
      final label = _serviceLabel(h.service).toLowerCase();
      if (label.contains(q)) return true;

      // Recherche par méthode
      if (h.method.toLowerCase().contains(q)) return true;

      return false;
    }).toList();
  }

  String _serviceLabel(PaymentServiceType t) {
    switch (t) {
      case PaymentServiceType.inscription:  return "inscription scolaire";
      case PaymentServiceType.mensualite:   return "frais de scolarité";
      case PaymentServiceType.cantine:      return "cantine scolaire";
      case PaymentServiceType.transport:    return "transport scolaire";
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);
    final ctrl = Get.find<PaymentHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          "Historique",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Barre de recherche ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => _searchQuery.value = v,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Nom, référence, type de paiement...",
                  hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon:
                  Icon(Icons.search_rounded, color: Colors.grey.shade400),
                  suffixIcon: Obx(() => _searchQuery.value.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: Colors.grey.shade400, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      _searchQuery.value = '';
                    },
                  )
                      : const SizedBox.shrink()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Filtres rapides par type ───────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: "Tous",
                  icon: Icons.list_rounded,
                  selected: _activeFilter == null,
                  onTap: () => setState(() => _activeFilter = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Inscription",
                  icon: Icons.school_rounded,
                  selected: _activeFilter == PaymentServiceType.inscription,
                  onTap: () => setState(() =>
                  _activeFilter = _activeFilter == PaymentServiceType.inscription
                      ? null
                      : PaymentServiceType.inscription),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Scolarité",
                  icon: Icons.receipt_long_rounded,
                  selected: _activeFilter == PaymentServiceType.mensualite,
                  onTap: () => setState(() =>
                  _activeFilter = _activeFilter == PaymentServiceType.mensualite
                      ? null
                      : PaymentServiceType.mensualite),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Cantine",
                  icon: Icons.restaurant_rounded,
                  selected: _activeFilter == PaymentServiceType.cantine,
                  onTap: () => setState(() =>
                  _activeFilter = _activeFilter == PaymentServiceType.cantine
                      ? null
                      : PaymentServiceType.cantine),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: "Transport",
                  icon: Icons.directions_bus_rounded,
                  selected: _activeFilter == PaymentServiceType.transport,
                  onTap: () => setState(() =>
                  _activeFilter = _activeFilter == PaymentServiceType.transport
                      ? null
                      : PaymentServiceType.transport),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Liste filtrée ──────────────────────────────────
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value && ctrl.histories.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryBlue),
                );
              }

              final filtered = _filtered(ctrl.histories.toList());

              if (ctrl.histories.isEmpty) {
                return _EmptyState(
                  icon: Icons.receipt_long_outlined,
                  message: "Aucune transaction effectuée.",
                );
              }

              if (filtered.isEmpty) {
                return _EmptyState(
                  icon: Icons.search_off_rounded,
                  message: "Aucun résultat pour cette recherche.",
                  sub: "Essayez un nom, une référence ou un type.",
                );
              }

              return RefreshIndicator(
                color: primaryBlue,
                onRefresh: ctrl.fetchAll,
                child: Column(
                  children: [
                    // Compteur résultats
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${filtered.length} transaction${filtered.length > 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtered.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _HistoryItem(
                              h: filtered[index], ctrl: ctrl);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── FILTER CHIP ───────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? primaryBlue
                : Colors.black.withValues(alpha: 0.08),
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: primaryBlue.withValues(alpha: 0.25),
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
                size: 14,
                color: selected ? Colors.white : Colors.grey.shade500),
            const SizedBox(width: 6),
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

// ── EMPTY STATE ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? sub;

  const _EmptyState({required this.icon, required this.message, this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
          if (sub != null) ...[
            const SizedBox(height: 6),
            Text(sub!,
                style: TextStyle(
                    color: Colors.grey.shade400, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

// ── ITEM CLIQUABLE ────────────────────────────────────────────
class _HistoryItem extends StatelessWidget {
  final PaymentHistory h;
  final PaymentHistoryController ctrl;

  const _HistoryItem({required this.h, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.paymentDetail, arguments: h),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border:
          Border.all(color: Colors.black.withValues(alpha: 0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icône service
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(ctrl.serviceIcon(h.service),
                    color: primaryBlue, size: 22),
              ),
              const SizedBox(width: 14),

              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.serviceLabel(h.service),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${h.childName} • ${_formatDate(h.date)}",
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "REF-${h.id.toUpperCase().substring(0, h.id.length.clamp(0, 8))}",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Montant + statut
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatAmount(h.amount),
                    style: const TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ctrl.statusBgColor(h.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ctrl.statusLabel(h.status),
                      style: TextStyle(
                        color: ctrl.statusColor(h.status),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 6),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey.shade300, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

  static String _formatAmount(int amount) {
    final s = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(' ');
      result.write(s[i]);
    }
    return '${result.toString()} FCFA';
  }
}