// features/history/pages/payment_detail_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_history_controller.dart';
import '../models/payment_history_model.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentHistory h = Get.arguments as PaymentHistory;
    final ctrl = Get.find<PaymentHistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      body: CustomScrollView(
        slivers: [
          // ─── HEADER ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF063D66),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Détail du paiement",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Dégradé
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF063D66), Color(0xFF1976D2)],
                      ),
                    ),
                  ),
                  // Cercles déco
                  Positioned(
                    top: -40, right: -40,
                    child: Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30, left: -30,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  // Contenu central
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icône service
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3)),
                          ),
                          child: Icon(
                            ctrl.serviceIcon(h.service),
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Montant
                        Text(
                          _formatAmount(h.amount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Type service
                        Text(
                          ctrl.serviceLabel(h.service),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Badge statut
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: ctrl.statusBgColor(h.status).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                ctrl.statusIcon(h.status),
                                size: 14,
                                color: ctrl.statusColor(h.status),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ctrl.statusLabel(h.status),
                                style: TextStyle(
                                  color: ctrl.statusColor(h.status),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── CORPS ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Section enfant
                  _SectionCard(
                    title: "Enfant",
                    icon: Icons.child_care_rounded,
                    rows: [
                      _InfoRow(label: "Nom complet", value: h.childName),
                      _InfoRow(label: "École", value: h.schoolName.isNotEmpty ? h.schoolName : "—"),
                      _InfoRow(label: "Niveau", value: h.grade.isNotEmpty ? h.grade : "—", isLast: true),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Section paiement
                  _SectionCard(
                    title: "Détails du paiement",
                    icon: Icons.receipt_long_rounded,
                    rows: [
                      _InfoRow(label: "Service", value: ctrl.serviceLabel(h.service)),
                      _InfoRow(label: "Montant", value: _formatAmount(h.amount), highlight: true),
                      _InfoRow(label: "Méthode", value: h.method),
                      _InfoRow(
                        label: "Mode",
                        value: _methodIcon(h.method),
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Section date & statut
                  _SectionCard(
                    title: "Informations",
                    icon: Icons.info_outline_rounded,
                    rows: [
                      _InfoRow(label: "Date", value: _formatDate(h.date)),
                      _InfoRow(label: "Heure", value: _formatTime(h.date)),
                      _InfoRow(
                        label: "Référence",
                        value: "${h.reference}",
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Bouton impression PDF
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _printReceipt(h, ctrl),
                      icon: const Icon(Icons.picture_as_pdf_rounded),
                      label: const Text("Imprimer le reçu PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF063D66),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Bouton retour
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text("Retour à l'historique"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF063D66),
                        side: const BorderSide(color: Color(0xFF063D66)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _printReceipt(
      PaymentHistory h,
      PaymentHistoryController ctrl,
      ) async {

    final pdf = pw.Document();

    final reference =
        "${h.reference}";


    final qrData =
        "https://eschool.itmaster-africa.com/api/receipt/$reference";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [

                // Titre
                pw.Text(
                  "REÇU DE PAIEMENT",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 20),

                // Infos
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Column(
                    children: [

                      _pdfRow("Enfant", h.childName),
                      _pdfRow("École", h.schoolName),
                      _pdfRow("Niveau", h.grade),
                      _pdfRow("Service", ctrl.serviceLabel(h.service)),
                      _pdfRow("Montant", _formatAmount(h.amount)),
                      _pdfRow("Méthode", h.method),
                      _pdfRow(
                        "Référence",
                        "REF-${h.id.toUpperCase().substring(0, h.id.length.clamp(0, 8))}",
                      ),
                      _pdfRow(
                        "Date",
                        "${_formatDate(h.date)} à ${_formatTime(h.date)}",
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 30),

                // QR CODE
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: qrData,
                  width: 120,
                  height: 120,
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  "Scannez pour vérifier le reçu",
                  style: const pw.TextStyle(fontSize: 10),
                ),

                pw.Spacer(),

                pw.Text(
                  "Merci pour votre paiement",
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 11,
            ),
          ),
          pw.Text(
            value.isEmpty ? "—" : value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
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

  static String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

  static String _formatTime(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}";

  static String _methodIcon(String method) {
    switch (method) {
      case 'Airtel Money':
        return '📱 Airtel Money';
      case 'Moov Money':
        return '📱 Moov Money';
      case 'Espèces':
        return '💵 Espèces';
      default:
        return method;
    }
  }
}

// ─── SECTION CARD ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_InfoRow> rows;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF063D66).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF063D66)),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Lignes
          ...rows,
        ],
      ),
    );
  }
}

// ─── INFO ROW ─────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool highlight;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: highlight ? FontWeight.w900 : FontWeight.w600,
                  color: highlight ? const Color(0xFF063D66) : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
      ],
    );
  }
}