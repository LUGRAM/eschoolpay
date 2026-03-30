import 'package:flutter/material.dart';
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
  var isAlreadyRegistered = false.obs;

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

      print('[RegistrationCtrl] confirmRegistration → anneeId=${annee.id} label=${annee.annee_scolaire}');
      print('[RegistrationCtrl] enfant=${child.fullName} école=${school.name} niveau=${level.name}');

      final result = await service.createInscription(
        eleveId: int.parse(child.id!),
        levelId: int.parse(level.id.toString()),
        anneeId: annee.id,
        ecoleId: int.parse(school.id.toString()),
        frais: isAlreadyRegistered.value
            ? 0
            : schoolsCtrl.inscriptionFee.value, // logique ajoutée
      );

      // SUCCESS
      final data = result['data'] ?? result;

      final updatedExtras = {
        ...child.extras,
        "school_id": (data['ecole']?['id'] ?? school.id).toString(),
        "school_name": (data['ecole']?['nom'] ?? school.name).toString(),
        "grade": (data['niveau']?['nom'] ?? level.name).toString(),
        "niveau_id": (data['niveau']?['id'] ?? level.id).toString(),
        "academic_year": annee.annee_scolaire ?? "",
      };

      childrenCtrl.updateChildExtras(child.id!, updatedExtras);

      Get.snackbar(
        "Succès",
        "Inscription enregistrée avec succès",
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {

      final message = e.toString().replaceAll("Exception: ", "");

      // CAS MÉTIER : déjà inscrit
      if (message.toLowerCase().contains("déjà inscrit")) {

        isAlreadyRegistered.value = true; // sync UI

        Get.snackbar(
          "Information",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

      } else {

        // AUTRES ERREURS
        Get.snackbar(
          "Erreur",
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } finally {
      isLoading.value = false;
    }
  }
}