// features/history/controllers/payment_history_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/annee_scolaire_controller.dart';
import '../../../core/network/api_client.dart';
import '../models/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  // ── Liste complète → HistoryPage ─────────────────────────────
  final histories = <PaymentHistory>[].obs;
  final isLoading = false.obs;

  // ── 5 derniers → HomeContent ─────────────────────────────────
  final recentHistories = <PaymentHistory>[].obs;
  final isLoadingRecent = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
    fetchAll();
  }

  // ─── Récupère l'annee_scolaire_id courant ────────────────────
  int get _anneeId {
    try {
       final id = Get.find<AnneeScolaireController>().selectedYear.value?.id ?? 1;
       print('📅 [HistoryCtrl] anneeId=$id');
       return id;
    } catch (_) {
      print('📅 [HistoryCtrl] anneeId=1 (fallback)');
      return 1;
    }
  }

  // ─── Parse le body commun aux deux endpoints ─────────────────
  List<PaymentHistory> _parseBody(Map<String, dynamic> body) {
    final List inscriptions = body['inscriptions'] ?? [];
    final List transactions = body['dernieres_transactions'] ?? [];

    final all = <PaymentHistory>[
      ...inscriptions.map((j) => PaymentHistory.fromInscriptionApi(j)),
      ...transactions.map((j) => PaymentHistory.fromTransactionApi(j)),
    ];

    all.sort((a, b) => b.date.compareTo(a.date));
    return all;
  }

  // ─── GET /api/parent/dashboard → HomeContent ────────────────
  Future<void> fetchDashboard() async {
    try {
      isLoadingRecent.value = true;
      final response = await ApiClient.get(
        '/parent/dashboard?annee_scolaire_id=$_anneeId',
      );

      debugPrint('🏠 dashboard status: ${response.statusCode}');

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final all = _parseBody(body);
      recentHistories.assignAll(all.take(5).toList());
    } catch (e) {
      debugPrint('❌ fetchDashboard: $e');
    } finally {
      isLoadingRecent.value = false;
    }
  }

  // ─── GET /api/parent/historique → HistoryPage ───────────────
  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.get(
        '/parent/historique?annee_scolaire_id=$_anneeId',
      );

      debugPrint('📋 historique status: ${response.statusCode}');

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      histories.assignAll(_parseBody(body));

      debugPrint('✅ historique: ${histories.length} entrées');
    } catch (e) {
      debugPrint('❌ fetchAll: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Ajout local après paiement confirmé ────────────────────
  void addHistory(PaymentHistory history) {
    histories.insert(0, history);
    // Met aussi à jour les récents si < 5
    if (recentHistories.length < 5) {
      recentHistories.insert(0, history);
    } else {
      recentHistories.insert(0, history);
      if (recentHistories.length > 5) recentHistories.removeLast();
    }
  }

  // ─── Labels & UI helpers ─────────────────────────────────────
  String serviceLabel(PaymentServiceType type) {
    switch (type) {
      case PaymentServiceType.inscription:  return "Inscription scolaire";
      case PaymentServiceType.mensualite:   return "Frais de scolarité";
      case PaymentServiceType.cantine:      return "Cantine scolaire";
      case PaymentServiceType.transport:    return "Transport scolaire";
    }
  }

  IconData serviceIcon(PaymentServiceType type) {
    switch (type) {
      case PaymentServiceType.inscription:  return Icons.school_rounded;
      case PaymentServiceType.mensualite:   return Icons.receipt_long_rounded;
      case PaymentServiceType.cantine:      return Icons.restaurant_rounded;
      case PaymentServiceType.transport:    return Icons.directions_bus_rounded;
    }
  }

  String statusLabel(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:  return "Succès";
      case PaymentStatus.pending:  return "En attente";
      case PaymentStatus.failed:   return "Échec";
    }
  }

  Color statusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:  return const Color(0xFF2E7D32);
      case PaymentStatus.pending:  return const Color(0xFFE65100);
      case PaymentStatus.failed:   return const Color(0xFFC62828);
    }
  }

  Color statusBgColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:  return const Color(0xFFE8F5E9);
      case PaymentStatus.pending:  return const Color(0xFFFFF3E0);
      case PaymentStatus.failed:   return const Color(0xFFFFEBEE);
    }
  }

  IconData statusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.success:  return Icons.check_circle_rounded;
      case PaymentStatus.pending:  return Icons.access_time_rounded;
      case PaymentStatus.failed:   return Icons.cancel_rounded;
    }
  }
}