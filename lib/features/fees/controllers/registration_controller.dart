import 'package:get/get.dart';

import '../../children/models/child_model.dart';
import '../models/registration_fee_model.dart';
import '../models/registration_record_model.dart';

class RegistrationController extends GetxController {
  final selectedChild = Rxn<ChildModel>();
  final selectedFee = Rxn<RegistrationFeeModel>();
  final totalAmount = 0.obs;

  final records = <RegistrationRecordModel>[].obs;

  List<String> get availableSchools =>
      mockRegistrationFees.map((e) => e.schoolName).toSet().toList();

  List<String> levelsForSchool(String schoolName) => mockRegistrationFees
      .where((e) => e.schoolName == schoolName)
      .map((e) => e.level)
      .toSet()
      .toList();

  void selectFee(String schoolName, String level) {
    selectedFee.value = mockRegistrationFees.firstWhere(
          (e) => e.schoolName == schoolName && e.level == level,
    );
    totalAmount.value = selectedFee.value!.amount;
  }

  bool get canProceed {
    final child = selectedChild.value;
    if (child == null) return false;
    if (child.isAlreadyRegisteredThisYear) return false;
    return selectedFee.value != null;
  }

  RegistrationRecordModel confirmRegistration() {
    final child = selectedChild.value!;
    final fee = selectedFee.value!;

    // ✅ 1) produire un enfant “mis à jour” (sans muter l’ancien)
    final updatedChild = child.copyWith(
      extras: {
        ...child.extras,
        "school_id": fee.schoolId,
        "school_name": fee.schoolName,
        "grade": fee.level,
        "academic_year": ChildModel.currentAcademicYear,
      },
    );

    final academicYear = updatedChild.extras["academic_year"];
    if (academicYear == null) {
      throw Exception("academic_year manquant sur l'enfant");
    }

    final record = RegistrationRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: updatedChild.id as String,
      childName: updatedChild.fullName,
      schoolName: fee.schoolName,
      grade: fee.level,
      amount: fee.amount,
      academicYear: academicYear, // ✅ String non-null
      date: DateTime.now(),
    );

    records.add(record);

    // optionnel: selectedChild devient l’enfant à jour
    selectedChild.value = updatedChild;

    return record;
  }

  List<RegistrationRecordModel> historyForChild(String childId) =>
      records.where((r) => r.childId == childId).toList();
}