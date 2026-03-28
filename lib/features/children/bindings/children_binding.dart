import 'package:get/get.dart';
import '../controllers/children_controller.dart';

class ChildrenBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut n'instancie le contrôleur que lors du premier Get.find()
    Get.lazyPut<ChildrenController>(() => ChildrenController());
  }
}