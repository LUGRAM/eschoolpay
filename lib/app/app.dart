import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'router/app_pages.dart';
import 'theme/app_theme.dart';

class ESchoolPayApp extends StatelessWidget {
  const ESchoolPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-SchoolPay',
      theme: AppTheme.light,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}
