import 'package:bantuschoolpay/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../app/router/routes.dart';
import '../../support/pages/about_faq_page.dart';
import '../../support/pages/faq_page.dart';
import '../../support/pages/privacy_policy_page.dart';

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
              onTap: () => Get.toNamed(Routes.editSheet), // Vers edit_sheet_page
            ),
          ]),

          const SizedBox(height: 25),

          // --- SECTION PRÉFÉRENCES ---
          _buildSectionTitle("Préférences"),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.share_outlined,
              title: "Partager l'application",
              trailing: const Text("Français", style: TextStyle(color: Colors.grey)),
              onTap: () async {
                Get.back();
                await Share.share(
                  "Télécharge Bantu SchoolPay pour payer les frais de scolarité de tes enfants en un clic ! https://bantuschoolpay.ga",
                  subject: "Paiement scolaire simplifié",
                );
              },
            ),
          ]),

          const SizedBox(height: 25),

          // --- SECTION SUPPORT ---
          _buildSectionTitle("Support"),
          _buildSettingsCard([
            _buildSettingsItem(
              icon: Icons.quiz_outlined,
              title: "FAQ",
              onTap: () => Get.to(() => const FAQPage()),
            ),
            _buildSettingsItem(
              icon: Icons.info_outline,
              title: "À propos de nous",
              onTap: () => Get.to(() => const AboutFaqPage()),
            ),
            _buildSettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: "Politique de confidentialité",
              onTap: () => Get.to(() => const PrivacyPolicyPage()),
            ),

          ]),

          const SizedBox(height: 40),

          _buildMenuItem(Icons.logout, "Déconnexion", () {
            Get.dialog(
              Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.red.shade400,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Titre
                      const Text(
                        "Déconnexion",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                        "Voulez-vous vraiment quitter\nl'application ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Boutons
                      Row(
                        children: [
                          // Annuler
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Confirmer
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                Get.back();
                                final box = await GetStorage();
                                box.remove("token");
                                box.remove("auth_token");
                                box.remove("parent_model_id");
                                // Nettoyage
                                Get.offAllNamed(Routes.phoneSignin);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade400,
                                      Colors.red.shade700,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Quitter",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              barrierDismissible: true,
            );
          }, color: Colors.redAccent),
          const SizedBox(height: 5),
          _buildMenuItem(Icons.clear, "Supprimer le compte", () {
            Get.dialog(
              Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.clear,
                          color: Colors.red.shade400,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Titre
                      const Text(
                        "Supprimer le compte",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                        "Voulez-vous vraiment supprimer votre compte ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Boutons
                      Row(
                        children: [
                          // Annuler
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Annuler",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Confirmer
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  // Appel API suppression
                                  final response = await ApiClient.deleteAccount();

                                  if (response) {
                                    Get.back();

                                    // Nettoyage stockage local (token, user…)
                                    final GetStorage box = GetStorage();
                                    box.remove("token");
                                    box.remove("auth_token");
                                    box.remove("parent_model_id");

                                    Get.offAllNamed(Routes.phoneSignin);

                                    Get.snackbar(
                                      "Succès",
                                      "Votre compte a été supprimé",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Erreur",
                                      "Impossible de supprimer le compte",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    "Erreur",
                                    "Une erreur est survenue",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade400,
                                      Colors.red.shade700,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Supprimer",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              barrierDismissible: true,
            );
          }, color: Colors.redAccent),

          // Version de l'app
          Center(
            child: Text("Bantu SchoolPay v1.0.2",
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

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color color = Colors.black87}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Effet de surbrillance si besoin (optionnel)
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        onTap: () {
          Get.back(); // Ferme le drawer avant de naviguer
          onTap();
        },
      ),
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