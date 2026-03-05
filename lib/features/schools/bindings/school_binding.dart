import 'package:get/get.dart';
import '../controllers/schools_controller.dart';
import '../services/school_service.dart';
import '../services/level_service.dart';

class SchoolsBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<SchoolsService>(() => SchoolsService());

    Get.lazyPut<LevelService>(() => LevelService());

    Get.lazyPut<SchoolsController>(() =>
        SchoolsController(
          Get.find<SchoolsService>(),
          Get.find<LevelService>(),
        )
    );
  }
}