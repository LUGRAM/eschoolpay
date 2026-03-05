import 'package:get/get.dart';
import '../models/level_model.dart';
import '../models/school_model.dart';
import '../services/level_service.dart';
import '../services/school_service.dart';

class SchoolsController extends GetxController {

  final SchoolsService schoolService;
  final LevelService levelService;

  SchoolsController(this.schoolService, this.levelService);

  final schools = <SchoolModel>[].obs;
  final levels = <LevelModel>[].obs;

  final selectedSchool = Rxn<SchoolModel>();
  final selectedLevel = Rxn<LevelModel>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final schoolData = await schoolService.fetchSchool();
      final levelData = await levelService.fetchLevels();

      schools.assignAll(schoolData);
      levels.assignAll(levelData);

      if (schools.isNotEmpty) {
        selectedSchool.value = schools.first;
      }
    } catch (e) {
      print("SchoolsController loadData error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectSchool(SchoolModel school) {
    selectedSchool.value = school;
  }

  void selectLevel(LevelModel level) {
    selectedLevel.value = level;
  }
}