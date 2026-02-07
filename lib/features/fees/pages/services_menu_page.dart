import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/router/routes.dart';
import '../../../app/widgets/page_scaffold.dart';
import '../controllers/fees_controller.dart';

class ServicesMenuPage extends StatelessWidget {
  const ServicesMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feesCtrl = Get.find<FeesController>();

    return PageScaffold(
      title: "Services Scolaires",
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          _menuCard(
              "Inscription",
              Icons.how_to_reg,
              Colors.blue,
                  () => _navToService(feesCtrl, ServiceType.inscription)
          ),
          _menuCard(
              "Scolarité",
              Icons.school,
              Colors.orange,
                  () => _navToService(feesCtrl, ServiceType.mensualite)
          ),
          _menuCard(
              "Cantine",
              Icons.restaurant,
              Colors.green,
                  () => _navToService(feesCtrl, ServiceType.cantine)
          ),
          _menuCard(
              "Transport",
              Icons.directions_bus,
              Colors.purple,
                  () => _navToService(feesCtrl, ServiceType.transport)
          ),
        ],
      ),
    );
  }

  void _navToService(FeesController ctrl, ServiceType type) {
    ctrl.currentService.value = type;
    ctrl.reset(); // ✅ Reset les sélections

    // ✅ Routage selon le service
    switch (type) {
      case ServiceType.inscription:
        Get.toNamed(Routes.feesStart); // Page d'inscription
        break;
      case ServiceType.mensualite:
        Get.toNamed(Routes.monthlyFeesStart); // Page mensualités (à créer si différente)
        break;
      case ServiceType.cantine:
        Get.toNamed(Routes.cantineStart); // ✅ Route cantine
        break;
      case ServiceType.transport:
        Get.toNamed(Routes.transportStart); // ✅ Route transport (à créer)
        break;
    }
  }

  Widget _menuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha:0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}