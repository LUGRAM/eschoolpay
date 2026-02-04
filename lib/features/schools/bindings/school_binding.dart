import 'package:get/get.dart';
import '../controllers/schools_controller.dart';

class SchoolsBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut : Le contrôleur n'est créé que si la page AddChildPage est affichée
    Get.lazyPut<SchoolsController>(() => SchoolsController());
  }
}