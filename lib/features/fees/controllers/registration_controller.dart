import 'package:get/get.dart';

import '../../children/models/child_model.dart';
import '../models/registration_fee_model.dart';
import '../models/registration_record_model.dart';

class RegistrationController extends GetxController {
  final selectedChild = Rxn<ChildModel>();
  final selectedFee = Rxn<RegistrationFeeModel>();

  final totalAmount = 0.obs;

  // Historique des inscriptions
  final records = <RegistrationRecordModel>[].obs;

  List<String> get availableSchools =>
      mockRegistrationFees.map((e) => e.schoolName).toSet().toList();

  List<String> levelsForSchool(String schoolName) =>
      mockRegistrationFees
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

    // rattachement à l’enfant
    child.schoolId = fee.schoolId;
    child.schoolName = fee.schoolName;
    child.grade = fee.level;
    child.academicYear = ChildModel.currentAcademicYear;

    final record = RegistrationRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: child.id,
      childName: child.fullName,
      schoolName: fee.schoolName,
      grade: fee.level,
      amount: fee.amount,
      academicYear: child.academicYear!,
      date: DateTime.now(),
    );

    records.add(record);
    return record;
  }

  List<RegistrationRecordModel> historyForChild(String childId) =>
      records.where((r) => r.childId == childId).toList();
}
