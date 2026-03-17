import 'package:eschoolpay/core/network/api_client.dart';
import 'package:get/get.dart';
import '../../children/models/child_model.dart';
import '../data/mock_transport_options.dart';
import '../models/cantine_option_model.dart';
import '../models/frais_scolaire_model.dart';
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
  final selectedFraisScolaire = Rxn<FraisScolaireModel>();
  final selectedCantineOption = Rxn<FraisScolaireModel>();
  final selectedTransportOption = Rxn<FraisScolaireModel>();
  final paymentMethod = 'Mobile Money'.obs;

  final type = RxString("");

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
        return selectedFraisScolaire;
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
  // List<MonthlyFeeOption> get availableMonthlyOptions {
  //   final child = selectedChild.value;
  //   if (child == null) return [];
  //
  //   final schoolId = child.extras["school_id"];
  //   final grade = child.extras["grade"];
  //
  //   if (schoolId == null || grade == null) return [];
  //
  //   return mockMonthlyFees
  //       .where((c) => c.schoolId == schoolId && c.level == grade)
  //       .expand((c) => c.options)
  //       .toList();
  // }

  // List<CantineOption> get availableCantineOptions {
  //   final child = selectedChild.value;
  //   if (child == null) return [];
  //
  //   final schoolId = child.extras["school_id"];
  //   if (schoolId == null) return [];
  //
  //   return cantineOptions.where((o) => o.schoolId == schoolId).toList();
  // }
  //
  // List<TransportOption> get availableTransportOptions {
  //   final child = selectedChild.value;
  //   if (child == null) return [];
  //
  //   final schoolId = child.extras["school_id"];
  //   if (schoolId == null) return [];
  //
  //   return transportOptions.where((o) => o.schoolId == schoolId).toList();
  // }

  // ─────────────────────────────────────────────────────
  // MONTANT TOTAL
  // ─────────────────────────────────────────────────────
  int get totalAmount {
    switch (currentService.value) {
      case ServiceType.mensualite:
        return selectedFraisScolaire.value?.montant.toInt() ?? 0;
      case ServiceType.cantine:
        return selectedCantineOption.value?.montant.toInt() ?? 0;
      case ServiceType.transport:
        return selectedTransportOption.value?.montant.toInt() ?? 0;
      default:
        return 0;
    }
  }

  // ─────────────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────────────
  // void selectChild(ChildModel child) {
  //   selectedChild.value = child;
  //   selectedMonthlyOption.value = null;
  //   selectedCantineOption.value = null;
  //   selectedTransportOption.value = null;
  // }

  RxnString selectedSchoolYearId = RxnString();
  RxList<FraisScolaireModel> fraisScolaires = <FraisScolaireModel>[].obs;
  RxList<FraisScolaireModel> fraisCantines = <FraisScolaireModel>[].obs;
  RxList<FraisScolaireModel> fraisTransports = <FraisScolaireModel>[].obs;

  RxBool isLoadingFrais = false.obs;

  void selectChild(ChildModel child, String schoolYearId, String type) async {
    print(type);

    selectedChild.value = child;
    selectedSchoolYearId.value = schoolYearId.toString();

    if (type == "MENSUEL") {
      await loadFraisScolaire(child.id!, schoolYearId.toString());
    } else if (type == "CANTINE") {
      await loadFraisCantinne(child.id!, schoolYearId.toString());
    } else {
      await loadFraisTrannsport(child.id!, schoolYearId.toString());
    }
  }

  Future<void> loadFraisScolaire(String childId, String yearId) async {
    try {

      isLoadingFrais.value = true;

      final result = await ApiClient.getFraisScolaire(
        childId: childId,
        yearId: yearId,
        type: "MENSUEL"
      );

      fraisScolaires.value = result;

      print(fraisScolaires);

    } catch (e) {
      print("Erreur chargement frais scolaires: $e");
    } finally {
      isLoadingFrais.value = false;
    }
  }

  Future<void> loadFraisCantinne(String childId, String yearId) async {

    try {

      isLoadingFrais.value = true;

      final result = await ApiClient.getFraisScolaire(
        childId: childId,
        yearId: yearId,
        type: "CANTINE"
      );

      fraisCantines.value = result;

      print(fraisCantines);

    } catch (e) {
      print("Erreur chargement frais scolaires: $e");
    } finally {
      isLoadingFrais.value = false;
    }
  }

  Future<void> loadFraisTrannsport(String childId, String yearId) async {

    try {

      isLoadingFrais.value = true;

      final result = await ApiClient.getFraisScolaire(
        childId: childId,
        yearId: yearId,
        type: "TRANSPORT"
      );

      fraisTransports.value = result;

      print(fraisTransports);

    } catch (e) {
      print("Erreur chargement frais scolaires: $e");
    } finally {
      isLoadingFrais.value = false;
    }
  }

  // ─────────────────────────────────────────────────────
  // MÉTHODE DE PAIEMENT
  // ─────────────────────────────────────────────────────
  Future<PaymentRecordModel> payNow({
    required String method,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final child = selectedChild.value!;

    // 1. DÉTERMINATION DU STATUT LOGIQUE
    // Si c'est en espèces, le statut est 'PENDING' (en attente),
    // sinon c'est 'SUCCESS' (considérant que l'API mobile money a répondu OK)
    final String status = (method == 'Espèces') ? 'PENDING' : 'SUCCESS';

    String label;
    switch (currentService.value) {
      case ServiceType.mensualite:
        label = selectedFraisScolaire.value?.libelle ?? "Mensualité";
        break;
      case ServiceType.cantine:
        label = "Cantine • ${selectedCantineOption.value?.libelle ?? ''}";
        break;
      case ServiceType.transport:
        label = "Transport • ${selectedTransportOption.value?.libelle ?? ''}";
        break;
      default:
        label = "Paiement Divers";
        break;
    }

    final record = PaymentRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: child.id as String,
      childName: child.fullName,
      feeLabel: label,
      amount: totalAmount,
      method: method,
      status: status, // On utilise la variable dynamique ici
      createdAt: DateTime.now(),
    );

    payments.insert(0, record);
    return record;
  }

  void reset() {
    selectedChild.value = null;
    selectedFraisScolaire.value = null;
    selectedCantineOption.value = null;
    selectedTransportOption.value = null;
    currentService.value = ServiceType.inscription;
    paymentMethod.value = 'Mobile Money';
  }
}