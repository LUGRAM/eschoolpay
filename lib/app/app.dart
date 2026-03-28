import 'package:bantuschoolpay/app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'binding/auth_binding.dart';
import 'router/app_pages.dart';
import 'theme/app_theme.dart';

class BantuSchoolPayApp extends StatelessWidget {
  const BantuSchoolPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bantu SchoolPay',
      theme: AppTheme.light,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      initialBinding: AuthBinding(),
    );
  }
}
