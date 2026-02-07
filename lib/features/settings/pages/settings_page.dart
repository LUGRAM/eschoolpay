import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../app/router/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF063D66);
    final profileCtrl = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text("Paramètres",
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // --- SECTION COMPTE ---
          _buildSectionTitle("Compte"),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.person_outline,
              title: "Informations personnelles",
              onTap: () => Get.toNamed(Routes.edit), // Vers edit_sheet_page
            ),
            _buildSettingsItem(
              icon: Icons.lock_outline,
              title: "Sécurité & Code PIN",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 25),

          // --- SECTION PRÉFÉRENCES ---
          _buildSectionTitle("Préférences"),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.notifications_none_rounded,
              title: "Notifications",
              trailing: Switch(
                value: true,
                onChanged: (v) {},
                activeColor: primaryBlue,
              ),
            ),
            _buildSettingsItem(
              icon: Icons.language_rounded,
              title: "Langue",
              trailing: const Text("Français", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 25),

          // --- SECTION SUPPORT ---
          _buildSectionTitle("Support"),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.quiz_outlined,
              title: "FAQ",
              onTap: () => Get.toNamed(Routes.faq),
            ),
            _buildSettingsItem(
              icon: Icons.contact_support_outlined,
              title: "Contactez-nous",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 40),

          // Version de l'app
          Center(
            child: Text("E-SCHOOLPAY v1.0.2",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12, letterSpacing: 1.1)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 8),
      child: Text(title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF063D66), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}