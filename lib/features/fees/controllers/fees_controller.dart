import 'package:get/get.dart';
import '../../children/models/child_model.dart';
import '../data/mock_transport_options.dart';
import '../models/cantine_option_model.dart';
import '../models/monthly_fee_config_model.dart';
import '../data/mock_monthly_fees_options.dart';
import '../data/mock_cantine_options.dart';
import '../models/payment_record_model.dart';
import '../models/transport_option_model.dart';

enum ServiceType { inscription, mensualite, cantine, transport }

class FeesController extends GetxController {
  final currentService = ServiceType.inscription.obs;

  // ─────────────────────────────────────────────────────
  // SÉLECTIONS
  // ─────────────────────────────────────────────────────
  final selectedChild = Rxn<ChildModel>();
  final selectedMonthlyOption = Rxn<MonthlyFeeOption>();
  final selectedCantineOption = Rxn<CantineOption>();
  final selectedTransportOption = Rxn<TransportOption>();
  final paymentMethod = 'Mobile Money'.obs;

  // ─────────────────────────────────────────────────────
  // HISTORIQUE DES PAIEMENTS
  // ─────────────────────────────────────────────────────
  final payments = <PaymentRecordModel>[].obs;

  List<PaymentRecordModel> paymentsForChild(String childId) {
    return payments.where((p) => p.childId == childId).toList();
  }

  // ─────────────────────────────────────────────────────
  // GETTER UNIFIÉ (utilisé par FeesPreviewPage)
  // ─────────────────────────────────────────────────────
  Rxn<dynamic> get selected {
    switch (currentService.value) {
      case ServiceType.mensualite:
        return selectedMonthlyOption;
      case ServiceType.cantine:
        return selectedCantineOption;
      case ServiceType.transport:
        return selectedTransportOption;
      default:
        return Rxn<dynamic>();
    }
  }

  // ─────────────────────────────────────────────────────
  // OPTIONS DISPONIBLES
  // ─────────────────────────────────────────────────────
  List<MonthlyFeeOption> get availableMonthlyOptions {
    final child = selectedChild.value;
    if (child == null || child.schoolId == null || child.grade == null) {
      return [];
    }

    return mockMonthlyFees
        .where((c) => c.schoolId == child.schoolId && c.level == child.grade)
        .expand((c) => c.options)
        .toList();
  }

  List<CantineOption> get availableCantineOptions {
    final child = selectedChild.value;
    if (child == null || child.schoolId == null) return [];

    return cantineOptions
        .where((o) => o.schoolId == child.schoolId)
        .toList();
  }

  List<TransportOption> get availableTransportOptions {
    final child = selectedChild.value;
    if (child == null || child.schoolId == null) return [];

    return transportOptions
        .where((o) => o.schoolId == child.schoolId)
        .toList();
  }

  // ─────────────────────────────────────────────────────
  // MONTANT TOTAL
  // ─────────────────────────────────────────────────────
  int get totalAmount {
    switch (currentService.value) {
      case ServiceType.mensualite:
        return selectedMonthlyOption.value?.finalAmount ?? 0;
      case ServiceType.cantine:
        return selectedCantineOption.value?.amount ?? 0;
      case ServiceType.transport:
        return selectedTransportOption.value?.amount ?? 0;
      default:
        return 0;
    }
  }

  // ─────────────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────────────
  void selectChild(ChildModel child) {
    selectedChild.value = child;
    selectedMonthlyOption.value = null;
    selectedCantineOption.value = null;
    selectedTransportOption.value = null;
  }

  // ─────────────────────────────────────────────────────
  // MÉTHODE DE PAIEMENT
  // ─────────────────────────────────────────────────────
  Future<PaymentRecordModel> payNow({
    required String method,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final child = selectedChild.value!;
    final status = 'SUCCESS';

    String label;
    switch (currentService.value) {
      case ServiceType.mensualite:
        label = "Mensualité • ${selectedMonthlyOption.value?.months ?? 0} mois";
        break;
      case ServiceType.cantine:
        label = "Cantine • ${selectedCantineOption.value?.label ?? ''}";
        break;
      case ServiceType.transport:
        label = "Transport • ${selectedTransportOption.value?.label ?? ''}";
        break;
      case ServiceType.inscription:
      default:
        label = "Inscription";
        break;
    }

    final record = PaymentRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: child.id,
      childName: child.fullName,
      feeLabel: label,
      amount: totalAmount,
      method: method,
      status: status,
      createdAt: DateTime.now(),
    );

    payments.insert(0, record);
    return record;
  }

  void reset() {
    selectedChild.value = null;
    selectedMonthlyOption.value = null;
    selectedCantineOption.value = null;
    selectedTransportOption.value = null;
    currentService.value = ServiceType.inscription;
    paymentMethod.value = 'Mobile Money';
  }
}