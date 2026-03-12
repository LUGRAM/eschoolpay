// features/history/controllers/payment_history_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../children/controllers/children_controller.dart';
import '../models/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  final histories = <PaymentHistory>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  // ─── Point d'entrée principal ────────────────────────────────
  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      histories.clear();

      final results = await Future.wait([
        fetchFromInscriptionsApi(),
        fetchFromFraisScolairesApi(),
      ]);

      final all = [...results[0], ...results[1]];
      all.sort((a, b) => b.date.compareTo(a.date));
      histories.assignAll(all);
    } catch (e) {
      debugPrint('❌ fetchAll: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── GET /api/inscriptions ───────────────────────────────────
  Future<List<PaymentHistory>> fetchFromInscriptionsApi() async {
    try {
      final response = await ApiClient.get('/inscriptions');
      if (response.statusCode != 200) return [];
      final body = jsonDecode(response.body);
      final List data = body['data'] ?? [];
      return data
          .map((json) => PaymentHistory.fromInscriptionApi(json))
          .toList();
    } catch (e) {
      debugPrint('❌ fetchFromInscriptionsApi: $e');
      return [];
    }
  }

  // ─── GET /api/frais-scolaires par enfant (temporaire) ────────
  Future<List<PaymentHistory>> fetchFromFraisScolairesApi() async {
    try {
      if (!Get.isRegistered<ChildrenController>()) return [];
      final children = Get.find<ChildrenController>().children;
      final List<PaymentHistory> result = [];

      for (final child in children) {
        final schoolId = child.extras['school_id'];
        final niveauId = child.extras['niveau_id'];
        if (schoolId == null || niveauId == null) continue;

        // annee_scolaire_id dynamique si disponible
        int anneeId = 2;
        try {
          anneeId = Get.find(tag: 'AnneeScolaireController')
              .selectedYear
              ?.value
              ?.id ?? 2;
        } catch (_) {}

        final response = await ApiClient.get(
          '/frais-scolaires?ecole_id=$schoolId&niveau_id=$niveauId&annee_scolaire_id=$anneeId',
        );
        if (response.statusCode != 200) continue;

        final body = jsonDecode(response.body);
        final List data = body['data'] ?? [];

        for (final json in data) {
          result.add(PaymentHistory.fromFraisScolairesApi(
            json,
            childName: child.fullName,
            childId: child.id ?? '',
            schoolName: child.extras['school_name'] ?? '',
            grade: child.extras['grade'] ?? '',
          ));
        }
      }

      return result;
    } catch (e) {
      debugPrint('❌ fetchFromFraisScolairesApi: $e');
      return [];
    }
  }

  // ─── Ajout après paiement confirmé ──────────────────────────
  void addHistory(PaymentHistory history) {
    histories.insert(0, history);
  }

  // ─── 4 derniers pour la HomePage ─────────────────────────────
  List<PaymentHistory> get recentPayments => histories.take(4).toList();

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