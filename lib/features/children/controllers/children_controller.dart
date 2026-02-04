// lib/features/children/controllers/children_controller.dart
import 'package:get/get.dart';
import '../models/child_model.dart';

class ChildrenController extends GetxController {
  final children = <ChildModel>[].obs;

  void addChild(ChildModel child) {
    children.add(child);
    Get.snackbar("Succès", "${child.firstName} a été ajouté(e)");
  }
}