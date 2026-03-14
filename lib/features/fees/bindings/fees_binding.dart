import 'package:eschoolpay/features/fees/controllers/registration_controller.dart';
import 'package:eschoolpay/features/schools/services/level_service.dart';
import 'package:get/get.dart';
import '../../children/controllers/children_controller.dart';
import '../../schools/controllers/schools_controller.dart';
import '../../schools/services/school_service.dart';
import '../controllers/fees_controller.dart';

class FeesBinding extends Bindings {
  @override
  void dependencies() {
    // Utilisation de lazyPut pour instancier le contrôleur uniquement au besoin
    Get.lazyPut<SchoolsService>(() => SchoolsService());
    Get.lazyPut<LevelService>(() => LevelService());

    Get.lazyPut<SchoolsController>(
          () => SchoolsController(
        Get.find<SchoolsService>(),
        Get.find<LevelService>(),
      ),
    );

    Get.lazyPut<ChildrenController>(() => ChildrenController());
    Get.lazyPut<FeesController>(() => FeesController());
    Get.lazyPut<FeesController>(() => FeesController());
    Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}