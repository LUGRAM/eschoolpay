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

      await service.createInscription(
        eleveId: int.parse(selectedChild.value!.id!),
        levelId: int.parse(schoolsCtrl.selectedLevel.value!.id as String),
        anneeId: anneeCtrl.selectedYear.value!.id,
        frais: 25000,
      );
    } finally {
      isLoading.value = false;
    }
  }
}