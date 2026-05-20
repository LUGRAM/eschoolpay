import 'package:get/get.dart';
import '../../../app/controllers/annee_scolaire_controller.dart';
import '../../children/models/child_model.dart';
import '../../fees/controllers/fees_controller.dart';
import '../../fees/data/mock_informatique_options.dart';
import '../../fees/models/frais_scolaire_model.dart';
import '../models/informatique_option.dart';

class InformatiqueController extends GetxController {
  // Accesseurs lazy — appelés uniquement quand les contrôleurs sont enregistrés
  FeesController get _fees => Get.find<FeesController>();
  AnneeScolaireController get _annee => Get.find<AnneeScolaireController>();

  final selectedOption = Rxn<InformatiqueOption>();

  // ─── Liste des options : API en priorité, mock en fallback ──────────────────
  List<InformatiqueOption> get options {
    final fromApi = _fees.fraisInformatique;
    if (fromApi.isNotEmpty) {
      return fromApi.map(InformatiqueOption.fromFrais).toList();
    }
    // Fallback : données simulées (backend pas encore configuré)
    return mockInformatiqueOptions.map(InformatiqueOption.fromFrais).toList();
  }

  bool get isLoadingOptions => _fees.isLoadingFrais.value;

  ChildModel? get selectedChild => _fees.selectedChild.value;

  int get totalAmount => selectedOption.value?.montant.toInt() ?? 0;

  // ─── Sélection de l'enfant → charge les options via l'API ────────────────────
  void selectChildAndLoad(ChildModel child) {
    final year = _annee.selectedYear.value;
    final normalizedYear = year == null
        ? null
        : _annee.schoolYears.firstWhereOrNull((e) => e.id == year.id);

    if (normalizedYear == null) {
      Get.snackbar(
        'Année scolaire manquante',
        'Veuillez sélectionner une année scolaire depuis l\'accueil.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    selectedOption.value = null;
    _fees.selectChild(child, normalizedYear.id.toString(), 'INFORMATIQUE');
  }

  // ─── Sélection d'une formation → synchronise FeesController ──────────────────
  void selectOption(InformatiqueOption option) {
    if (_fees.selectedChild.value == null) {
      Get.snackbar(
        'Enfant requis',
        'Veuillez d\'abord sélectionner un enfant.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    selectedOption.value = option;
    _fees.currentService.value = ServiceType.informatique;

    // Cherche le FraisScolaireModel correspondant dans la liste API
    final frais = _fees.fraisInformatique.firstWhereOrNull(
      (f) => f.id == option.id,
    );

    // Crée un FraisScolaireModel compatible si non trouvé (options statiques)
    _fees.selectedInformatiqueOption.value = frais ??
        FraisScolaireModel(
          id: option.id ?? '0',
          ecoleId: '',
          niveauId: '',
          anneeScolaireId: '',
          libelle: '${option.niveau} - ${option.titre}',
          montant: option.montant,
        );
  }

  void reset() {
    selectedOption.value = null;
    _fees.selectedInformatiqueOption.value = null;
    _fees.fraisInformatique.clear();
  }
}
