import 'package:get/get.dart';
import '../../../app/controllers/annee_scolaire_controller.dart';
import '../../children/models/child_model.dart';
import '../../children/controllers/children_controller.dart';
import '../../schools/controllers/schools_controller.dart';
import '../services/insription_service.dart';

class RegistrationController extends GetxController {
  final ChildrenController childrenCtrl = Get.find();
  final SchoolsController schoolsCtrl = Get.find();
  final AnneeScolaireController anneeCtrl = Get.find();
  final InscriptionService service = InscriptionService();

  final selectedChild = Rxn<ChildModel>();
  final isLoading = false.obs;

  bool get canProceed {
    return selectedChild.value != null &&
        schoolsCtrl.selectedSchool.value != null &&
        schoolsCtrl.selectedLevel.value != null;
  }

  Future<void> confirmRegistration() async {
    if (!canProceed) return;

    try {
      isLoading.value = true;
      final child = selectedChild.value!;
      final school = schoolsCtrl.selectedSchool.value!;
      final level = schoolsCtrl.selectedLevel.value!;
      final annee = anneeCtrl.selectedYear.value!;

      print('📅 [RegistrationCtrl] confirmRegistration → anneeId=${annee.id} label=${annee.annee_scolaire}');
      print('📅 [RegistrationCtrl] enfant=${child.fullName} école=${school.name} niveau=${level.name}');

      final result = await service.createInscription(
        eleveId: int.parse(child.id!),
        levelId: int.parse(level.id.toString()),
        anneeId: annee.id,
        ecoleId: int.parse(school.id.toString()),
        frais: schoolsCtrl.inscriptionFee.value,
      );

      // ✅ Mise à jour des extras de l'enfant avec les données d'inscription
      final data = result['data'] ?? result;
      final updatedExtras = {
        ...child.extras,
        "school_id": (data['ecole']?['id'] ?? school.id).toString(),
        "school_name": (data['ecole']?['nom'] ?? school.name).toString(),
        "grade": (data['niveau']?['nom'] ?? level.name).toString(),
        "niveau_id": (data['niveau']?['id'] ?? level.id).toString(),
        "academic_year": annee.annee_scolaire ?? "",
      };

      // ✅ Mise à jour dans ChildrenController
      childrenCtrl.updateChildExtras(child.id!, updatedExtras);

    } finally {
      isLoading.value = false;
    }
  }
}