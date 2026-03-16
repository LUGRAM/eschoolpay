import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart'; // N'oublie pas d'ajouter ce package dans ton pubspec.yaml
import '../../features/profile/controllers/profile_controller.dart';
import '../../features/support/pages/about_faq_page.dart';
import '../../features/support/pages/faq_page.dart';
import '../router/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          _buildMenuItem(Icons.privacy_tip_outlined, "Politique de confidentialité", () {
            // Logique WebView ou Dialog
          }),
          _buildMenuItem(Icons.info_outline, "À propos de nous", () {
            Get.to(() => const AboutFaqPage());
          }),
          _buildMenuItem(Icons.share_outlined, "Partager l'application", () async {
            Get.back();
            await Share.share(
              "Télécharge E-SCHOOLPAY pour payer les frais de scolarité de tes enfants en un clic ! https://eschoolpay.ga",
              subject: "Paiement scolaire simplifié",
            );
          }),
          _buildMenuItem(Icons.quiz_outlined, "FAQ", () {
            Get.to(() => const FAQPage()); // Si tu n'as pas encore défini de route nommée
          }),

          const Spacer(), // Pousse la déconnexion vers le bas
          const Divider(),

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
                              onTap: () {
                                Get.back();
                                // Nettoyage
                                Get.offAllNamed(Routes.authWelcome);
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
          
          const SizedBox(height: 20),
        ],
      ),
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

  Widget _buildHeader() {
    final profileCtrl = Get.find<ProfileController>();
    return Obx(() {
      final user = profileCtrl.profile.value;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
        decoration: const BoxDecoration(
          color: Color(0xFF063D66),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
              child: user?.photoUrl == null ? const Icon(Icons.person, size: 40, color: Color(0xFF063D66)) : null,
            ),
            const SizedBox(height: 15),
            Text(
              user?.name ?? "Parent Utilisateur",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              user?.email ?? "parent@email.com",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    });
  }





}