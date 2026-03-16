// features/timelinepay/pages/payment_timeline_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../children/controllers/children_controller.dart';
import '../../children/models/child_model.dart';
import '../../history/controllers/payment_history_controller.dart';
import '../../history/models/payment_history_model.dart';

class PaymentTimelinePage extends StatelessWidget {
  const PaymentTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);
    final childrenCtrl = Get.find<ChildrenController>();
    final histCtrl = Get.find<PaymentHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text(
          "Suivi de Scolarité",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: primaryBlue),
            onPressed: histCtrl.fetchAll,
          ),
        ],
      ),
      body: Obx(() {
        // ── Loading ───────────────────────────────────────────
        if (histCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }

        // ── Aucun enfant ──────────────────────────────────────
        if (childrenCtrl.children.isEmpty) {
          return _EmptyState(
            icon: Icons.child_care_outlined,
            message: "Aucun enfant enregistré.",
          );
        }

        return RefreshIndicator(
          color: primaryBlue,
          onRefresh: histCtrl.fetchAll,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: childrenCtrl.children.length,
            itemBuilder: (context, i) {
              final child = childrenCtrl.children[i];

              // Filtre les paiements de cet enfant
              final childPayments = histCtrl.histories
                  .where((h) =>
              h.childId.toString() == child.id.toString())
                  .toList()
                ..sort((a, b) => a.date.compareTo(b.date));

              return _ChildTimelineCard(
                child: child,
                payments: childPayments,
                histCtrl: histCtrl,
              );
            },
          ),
        );
      }),
    );
  }
}

// ── CARTE PAR ENFANT ──────────────────────────────────────────
class _ChildTimelineCard extends StatelessWidget {
  final ChildModel child;
  final List<PaymentHistory> payments;
  final PaymentHistoryController histCtrl;

  const _ChildTimelineCard({
    required this.child,
    required this.payments,
    required this.histCtrl,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);

    final inscriptions = payments
        .where((p) => p.service == PaymentServiceType.inscription)
        .toList();
    final mensualites = payments
        .where((p) => p.service == PaymentServiceType.mensualite)
        .toList();

    // Dernier paiement SUCCESS pour le player
    final lastSuccess = payments
        .where((p) =>
    p.status == PaymentStatus.success &&
        p.service != PaymentServiceType.inscription)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final activePayment = lastSuccess.isNotEmpty ? lastSuccess.first : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête enfant ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      child.fullName.isNotEmpty
                          ? child.fullName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        child.extras['grade']?.isNotEmpty == true
                            ? "${child.extras['grade']} • ${child.extras['school_name'] ?? ''}"
                            : "Non inscrit",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                if (payments.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${payments.length} pmt",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          if (payments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Aucun paiement pour cet enfant.",
                  style: TextStyle(
                      color: Colors.grey.shade400, fontSize: 13),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── AUDIO PLAYER — dernier paiement actif ────
                  if (activePayment != null) ...[
                    _AudioPlayerTimeline(
                      payment: activePayment,
                      histCtrl: histCtrl,
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── AUDIO PLAYER TIMELINE ─────────────────────────────────────
class _AudioPlayerTimeline extends StatelessWidget {
  final PaymentHistory payment;
  final PaymentHistoryController histCtrl;

  const _AudioPlayerTimeline({
    required this.payment,
    required this.histCtrl,
  });

  /// Durée couverte par le paiement (déduite du grade/libelle)
  Duration get _duration {
    final label = payment.grade.toLowerCase();
    if (label.contains('3 mois')) return const Duration(days: 90);
    if (label.contains('2 mois')) return const Duration(days: 60);
    if (label.contains('1 mois') || label.contains('mensuel')) {
      return const Duration(days: 30);
    }
    if (label.contains('trimestre')) return const Duration(days: 90);
    if (label.contains('semestre')) return const Duration(days: 180);
    if (label.contains('année') || label.contains('annuel')) {
      return const Duration(days: 365);
    }
    // Inscription → validité 1 an
    if (payment.service == PaymentServiceType.inscription) {
      return const Duration(days: 365);
    }
    return const Duration(days: 30);
  }

  double get _progress {
    final now = DateTime.now();
    final elapsed = now.difference(payment.date);
    final total = _duration;
    if (elapsed.isNegative) return 0.0;
    return (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);
  }

  String get _elapsed {
    final d = DateTime.now().difference(payment.date);
    if (d.inDays >= 1) return "${d.inDays}j écoulés";
    if (d.inHours >= 1) return "${d.inHours}h écoulées";
    return "${d.inMinutes}min";
  }

  String get _remaining {
    final end = payment.date.add(_duration);
    final remaining = end.difference(DateTime.now());
    if (remaining.isNegative) return "Expiré";
    if (remaining.inDays >= 1) return "${remaining.inDays}j restants";
    return "${remaining.inHours}h restantes";
  }

  String get _durationLabel {
    final label = payment.grade;
    return label.isNotEmpty ? label : "Période";
  }

  bool get _isExpired => _progress >= 1.0;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF063D66);
    final prog = _progress;
    final barColor = _isExpired
        ? Colors.red.shade400
        : prog > 0.8
        ? Colors.orange.shade600
        : primaryBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label "Dernier paiement actif"
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: barColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _isExpired
                    ? Icons.timer_off_rounded
                    : Icons.play_circle_filled_rounded,
                size: 14,
                color: barColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isExpired
                  ? "Dernier paiement — Expiré"
                  : "Dernier paiement actif",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: barColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Service + montant
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              histCtrl.serviceLabel(payment.service),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              _formatAmount(payment.amount),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: barColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ── Barre de progression style audio player ───────────
        Stack(
          children: [
            // Track fond
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Track rempli
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              height: 8,
              width: (MediaQuery.of(context).size.width - 64) * prog,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isExpired
                      ? [Colors.red.shade300, Colors.red.shade500]
                      : prog > 0.8
                      ? [Colors.orange.shade400, Colors.orange.shade600]
                      : [const Color(0xFF063D66), const Color(0xFF1976D2)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: barColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            // Curseur (thumb)
            if (prog > 0.02 && prog < 0.98)
              Positioned(
                left: (MediaQuery.of(context).size.width - 64) * prog - 6,
                top: -3,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: barColor,
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Temps écoulé / restant + durée
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _elapsed,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _durationLabel,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _remaining,
              style: TextStyle(
                fontSize: 10,
                color: _isExpired ? Colors.red : barColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

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

// ── SECTION TIMELINE HORIZONTALE ─────────────────────────────
class _TimelineSection extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final List<PaymentHistory> payments;
  final PaymentHistoryController histCtrl;
  final bool showProgress;

  const _TimelineSection({
    required this.label,
    required this.icon,
    required this.color,
    required this.payments,
    required this.histCtrl,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final successCount =
        payments.where((p) => p.status == PaymentStatus.success).length;
    final total = payments.length;
    final progress = total > 0 ? successCount / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
            const Spacer(),
            if (showProgress)
              Text(
                "$successCount/$total réglés",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (showProgress) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : color,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: payments.length,
            itemBuilder: (context, i) {
              return _TimelineNode(
                payment: payments[i],
                index: i + 1,
                isLast: i == payments.length - 1,
                color: color,
                histCtrl: histCtrl,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── NOEUD ─────────────────────────────────────────────────────
class _TimelineNode extends StatelessWidget {
  final PaymentHistory payment;
  final int index;
  final bool isLast;
  final Color color;
  final PaymentHistoryController histCtrl;

  const _TimelineNode({
    required this.payment,
    required this.index,
    required this.isLast,
    required this.color,
    required this.histCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = payment.status == PaymentStatus.success;
    final isPending = payment.status == PaymentStatus.pending;
    final isFailed = payment.status == PaymentStatus.failed;

    final nodeColor = isSuccess
        ? const Color(0xFF2E7D32)
        : isPending
        ? const Color(0xFFE65100)
        : Colors.grey.shade400;

    final nodeIcon = isSuccess
        ? Icons.check_rounded
        : isPending
        ? Icons.access_time_rounded
        : Icons.close_rounded;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            _PaymentMiniDetail(payment: payment, histCtrl: histCtrl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFailed
                      ? const Color(0xFFFFEBEE)
                      : isSuccess
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  border: Border.all(color: nodeColor, width: 2),
                  boxShadow: isSuccess
                      ? [
                    BoxShadow(
                      color: nodeColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                      : [],
                ),
                child: Icon(nodeIcon, size: 18, color: nodeColor),
              ),
              const SizedBox(height: 5),
              Text(
                "${payment.date.day.toString().padLeft(2, '0')}/${payment.date.month.toString().padLeft(2, '0')}",
                style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                _shortAmount(payment.amount),
                style: TextStyle(
                    fontSize: 9,
                    color: color,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
          if (!isLast)
            Container(
              width: 28,
              height: 2,
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isSuccess
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                    : Colors.grey.shade200,
              ),
            ),
        ],
      ),
    );
  }

  static String _shortAmount(int amount) {
    if (amount >= 1000) return "${(amount / 1000).toStringAsFixed(0)}k";
    return "$amount";
  }
}

// ── MINI DÉTAIL bottom sheet ──────────────────────────────────
class _PaymentMiniDetail extends StatelessWidget {
  final PaymentHistory payment;
  final PaymentHistoryController histCtrl;

  const _PaymentMiniDetail({required this.payment, required this.histCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: histCtrl.statusBgColor(payment.status),
              shape: BoxShape.circle,
            ),
            child: Icon(histCtrl.statusIcon(payment.status),
                color: histCtrl.statusColor(payment.status), size: 28),
          ),
          const SizedBox(height: 12),
          Text(histCtrl.serviceLabel(payment.service),
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 4),
          Text(payment.childName,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 16),
          _row("Montant", _fmt(payment.amount)),
          _row("Date", _fmtDate(payment.date)),
          _row("Méthode", payment.method),
          _row("Statut", histCtrl.statusLabel(payment.status),
              color: histCtrl.statusColor(payment.status)),
          if (payment.reference != null)
            _row("Référence", payment.reference!),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () => Get.back(),
                child: const Text("Fermer")),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: color ?? const Color(0xFF1A1A2E))),
      ],
    ),
  );

  static String _fmt(int amount) {
    final s = amount.toString();
    final r = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) r.write(' ');
      r.write(s[i]);
    }
    return '${r.toString()} FCFA';
  }

  static String _fmtDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
}

// ── EMPTY STATE ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(message,
            style: const TextStyle(color: Colors.grey, fontSize: 15)),
      ],
    ),
  );
}