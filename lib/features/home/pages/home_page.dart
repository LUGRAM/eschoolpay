import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/router/routes.dart';
import '../../../app/widgets/app_drawer.dart';
import '../../children/controllers/children_controller.dart';
import '../../fees/controllers/fees_controller.dart';
import '../../history/controllers/payment_history_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/pages/edit_sheet_page.dart';

import '../../history/pages/history_page.dart';
import '../../timelinepay/pages/payment_timeline_page.dart';
import '../../notifications/pages/notifications_page.dart';
import '../../settings/pages/settings_page.dart';
import '../widgets/home_content.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: ESchoolHomePage(),
));

class ESchoolHomePage extends StatefulWidget {
  const ESchoolHomePage({super.key});

  @override
  State<ESchoolHomePage> createState() => _ESchoolHomePageState();
}

class _ESchoolHomePageState extends State<ESchoolHomePage> {
  int _selectedIndex = 2; // Home par défaut
  final Color primaryBlue = const Color(0xFF063D66);

  // La liste des pages est maintenant propre
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // 1. On injecte d'abord les contrôleurs nécessaires (en dehors de la liste des pages)
    Get.put(PaymentHistoryController());
    Get.put(ProfileController());
    Get.put(ChildrenController()); // Ajoute ceux dont tu as besoin
    Get.put(FeesController());

    // 2. La liste ne doit contenir QUE des Widgets (Pages)
    _pages = [
      const HistoryPage(),          // Index 0
      const PaymentTimelinePage(),   // Index 1
      const HomeContent(),           // Index 2 (Home par défaut)
      const NotificationsPage(),    // Index 3
      const SettingsPage(),         // Index 4
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
// On utilise un Builder pour que le bouton menu puisse trouver le Scaffold
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: Icon(Icons.menu, color: primaryBlue),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Text(
            "E-SCHOOLPAY",
            style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
            )
        ),
        centerTitle: true,
// Dans home_page.dart
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Get.to(() => const EditProfileSheet()),
// Ouvre ton composant de profil
              child: Obx(() {
// Accès au contrôleur pour récupérer la photo du parent
                final profileCtrl = Get.find<ProfileController>();
                final photoUrl = profileCtrl.profile.value?.photoUrl;

                return CircleAvatar(
                  backgroundColor: primaryBlue,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl)
                      : null,
                  child: photoUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                );
              }),
            ),
          ),
        ],
      ),

      // Utilisation de IndexedStack pour garder l'état des pages
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: Container(
        height: 80,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          // Cette décoration crée l'élévation douce autour de la barre
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Ombre très légère
              blurRadius: 20,                        // Rayon de flou important pour la douceur
              offset: const Offset(0, -5),           // Vers le haut pour l'effet d'élévation
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(width, 80),
              painter: BNBCustomPainter(selectedIndex: _selectedIndex),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.history_rounded, 0),
                _buildNavItem(Icons.assignment_outlined, 1),
                _buildNavItem(Icons.home_rounded, 2),
                _buildNavItem(Icons.notifications_none_rounded, 3),
                _buildNavItem(Icons.settings_outlined, 4),
              ],
            ),
          ],
        ),
      ),    );
  }


  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceOut,
        width: 50, height: 50,
        margin: EdgeInsets.only(bottom: isSelected ? 40 : 0),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected ? [BoxShadow(color: primaryBlue.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))] : [],
        ),
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black26, size: 26),
      ),
    );
  }
}

// --- PAINTER CORRIGÉ (SANS LE TRUC BLANC EN HAUT À DROITE) ---
class BNBCustomPainter extends CustomPainter {
  final int selectedIndex;
  BNBCustomPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    // Changement pour un blanc pur "Pinterest style"
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double itemWidth = size.width / 5;
    double centerX = (itemWidth * selectedIndex) + (itemWidth / 2);

    // Dessin du rectangle de base arrondi
    RRect fullRect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(30));

    // Chemin de l'encoche
    Path notchPath = Path();
    notchPath.moveTo(centerX - 45, 0);
    notchPath.cubicTo(centerX - 30, 0, centerX - 25, 40, centerX, 40);
    notchPath.cubicTo(centerX + 25, 40, centerX + 30, 0, centerX + 45, 0);
    notchPath.lineTo(centerX - 45, 0);

    Path mainPath = Path()..addRRect(fullRect);

    // On soustrait l'encoche du rectangle proprement
    Path finalPath = Path.combine(PathOperation.difference, mainPath, notchPath);

    canvas.drawShadow(finalPath, Colors.black.withOpacity(0.1), 10, true);
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant BNBCustomPainter oldDelegate) => oldDelegate.selectedIndex != selectedIndex;
}

