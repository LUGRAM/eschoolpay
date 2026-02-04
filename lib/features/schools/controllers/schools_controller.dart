import 'package:get/get.dart';
import '../data/mock_schools.dart';
import '../models/school_model.dart';
import '../models/class_level_model.dart';

class SchoolsController extends GetxController {
  final schools = mockSchools.obs;

  final selectedSchool = Rxn<SchoolModel>();
  final selectedLevel = Rxn<ClassLevelModel>();

  List<ClassLevelModel> get availableLevels {
    return selectedSchool.value?.levels ?? [];
  }

  void selectSchool(SchoolModel school) {
    selectedSchool.value = school;
    selectedLevel.value = null; // reset classe
  }

  void selectLevel(ClassLevelModel level) {
    selectedLevel.value = level;
  }
}
