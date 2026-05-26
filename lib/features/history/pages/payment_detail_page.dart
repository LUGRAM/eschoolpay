// features/history/pages/payment_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/payment_history_controller.dart';
import '../models/payment_history_model.dart';
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

    final fontRegular = await PdfGoogleFonts.poppinsRegular();
    final fontBold    = await PdfGoogleFonts.poppinsBold();

    // ✅ Chargement du logo depuis les assets Flutter
    final logoBytes = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final String refLabel =
        h.reference ?? "REF-${h.id.split('-').last.toUpperCase()}";
    final qrData =
        "https://eschool.itmaster-africa.com/api/receipt/$refLabel";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(28),
        theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
        build: (context) {
          return pw.Stack(
            children: [
              // ─── 1. FILIGRANE (Placé en premier -> Arrière-plan) ───
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Transform.rotate(
                    angle: -0.5,
                    child: pw.Text(
                      h.status == PaymentStatus.success ? "PAYÉ" : "EN ATTENTE",
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: h.status == PaymentStatus.success ? 75 : 48,
                        // ✅ Opacité légèrement réduite (0.06) pour fondre le texte dans le décor
                        color: const PdfColor(0.75, 0.75, 0.75, 0.06),
                      ),
                    ),
                  ),
                ),
              ),

              // ─── 2. CONTENU PRINCIPAL (Placé en second -> Premier plan) ───
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // ── Header : logo + badge statut ──
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Row(
                        children: [
                          pw.Image(logoImage, width: 36, height: 36),
                          pw.SizedBox(width: 8),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "Bantu",
                                style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex("#063D66"),
                                ),
                              ),
                              pw.Text(
                                "SchoolPay",
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColor.fromHex("#1976D2"),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 18),

                  // ── Montant ──
                  pw.Text(
                    "Reçu de Paiement",
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    _formatAmount(h.amount),
                    style: pw.TextStyle(
                      fontSize: 30,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    width: 36, height: 3,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("#063D66"),
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                  ),

                  pw.SizedBox(height: 18),

                  // ── Tableau des détails (Désormais 100% lisible au premier plan) ──
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(14),
                      border: pw.Border.all(
                        color: PdfColors.grey300,
                        width: 1,
                      ),
                    ),
                    child: pw.Column(
                      children: [
                        _pdfRow("Élève",           h.childName),
                        _pdfDivider(),
                        _pdfRow("Niveau / Classe", h.grade.isNotEmpty ? h.grade : "—"),
                        _pdfDivider(),
                        _pdfRow("Service",         ctrl.serviceLabel(h.service)),
                        _pdfDivider(),
                        _pdfRow("Montant",         _formatAmount(h.amount)),
                        _pdfDivider(),
                        _pdfRow("Méthode",         h.method),
                        _pdfDivider(),
                        _pdfRow("Référence",       refLabel),
                        _pdfDivider(),
                        _pdfRow("Date & Heure",    "${_formatDate(h.date)} à ${_formatTime(h.date)}"),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 16),

                  // ── Ligne pointillée ──
                  pw.Container(
                    width: double.infinity, height: 1,
                    child: pw.CustomPaint(
                      painter: (canvas, size) {
                        canvas.setStrokeColor(PdfColors.grey300);
                        canvas.setLineWidth(0.8);
                        canvas.setLineDashPattern([4, 4]);
                        canvas.drawLine(0, 0, size.x, 0);
                        canvas.strokePath();
                      },
                    ),
                  ),

                  pw.SizedBox(height: 14),

                  // ── Footer : contact + QR ──
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Besoin d'aide ?",
                            style: pw.TextStyle(
                                fontSize: 9, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            "support@itmaster-africa.com",
                            style: const pw.TextStyle(
                                fontSize: 8, color: PdfColors.black),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            "Document généré par Bantu SchoolPay",
                            style: pw.TextStyle(
                              fontSize: 7,
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColors.grey500,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: qrData,
                            width: 56, height: 56,
                            color: PdfColors.black,
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "VÉRIFIER",
                            style: pw.TextStyle(
                                fontSize: 7, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }


// Séparateur léger entre les lignes du tableau PDF
  static pw.Widget _pdfDivider() => pw.Container(
    height: 0.5,
    color: PdfColors.grey300,
    margin: const pw.EdgeInsets.symmetric(vertical: 2),
  );

  // Row de données optimisée : étiquettes grisées, valeurs sombres et bien visibles
  static pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 11,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 11,
              color: PdfColor.fromHex("#0b0b0b"),
            ),
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