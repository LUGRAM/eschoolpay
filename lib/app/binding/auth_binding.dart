import 'package:get/get.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../controllers/annee_scolaire_controller.dart';
import '../data/services/annee_scolaire_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
          () => AuthController(),
      fenix: true,
    );

    Get.lazyPut(() => AnneeScolaireService());
    Get.lazyPut(() => AnneeScolaireController(Get.find<AnneeScolaireService>()), fenix: true);
  }
}
