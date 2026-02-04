import 'package:eschoolpay/features/fees/controllers/registration_controller.dart';
import 'package:get/get.dart';
import '../controllers/fees_controller.dart';

class FeesBinding extends Bindings {
  @override
  void dependencies() {
    // Utilisation de lazyPut pour instancier le contrôleur uniquement au besoin
    Get.lazyPut<FeesController>(() => FeesController());
    Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}