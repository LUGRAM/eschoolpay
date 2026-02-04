import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'features/children/controllers/children_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ChildrenController(), permanent: true);
  //Get.put(Controller(), permanent: true);
  //Get.put(ChildrenController(), permanent: true);
  runApp(const ESchoolPayApp());
}
