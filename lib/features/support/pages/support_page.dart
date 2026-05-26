import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bantuschoolpay/app/theme/app_colors.dart';

import '../../../app/widgets/network_error_card.dart';
import '../models/info_site.dart';
import '../services/info_site_service.dart';
import 'privacy_policy_page.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  late Future<InfoSite?> _future;

  @override
  void initState() {
    super.initState();
    _future = InfoSiteService.fetchInfoSite();
  }

  void _reload() {
    setState(() {
      _future = InfoSiteService.fetchInfoSite();
    });
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Support"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<InfoSite?>(
      future: _future,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return NetworkErrorCard(
            title: "Connexion indisponible",
            message:
            "Impossible de charger les informations.\nVérifiez votre connexion internet puis réessayez.",
            onRetry: _reload,
          );
        }


        if (!snapshot.hasData) {
          return const Center(child: Text("Impossible de charger les informations"));
        }

        final info = snapshot.data!;


        return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ------------------------------------------------------------
              // 🔹 SUPPORT DIRECT
              // ------------------------------------------------------------
              const Text(
                "Assistance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPast),
              ),
              const SizedBox(height: 10),

              if (info.whatsapp != null)
                _tile(
                  icon: FontAwesomeIcons.whatsapp,
                  iconColor: AppColors.whatsapp,
                  title: "Assistance WhatsApp",
                  subtitle: info.whatsapp!,
                  onTap: () => _open("https://wa.me/${info.whatsapp!.replaceAll('+', '')}"),
                ),

              if (info.email != null)
                _tile(
                  icon: Icons.email_rounded,
                  iconColor: AppColors.gmail,
                  title: "Email support",
                  subtitle: info.email!,
                  onTap: () => _open("mailto:${info.email}"),
                ),

              if (info.telephone != null)
                _tile(
                  icon: Icons.phone_in_talk_rounded,
                  iconColor: Colors.blue,
                  title: "Appeler le support",
                  subtitle: info.telephone!,
                  onTap: () => _open("tel:${info.telephone}"),
                ),

              const SizedBox(height: 30),

              // ------------------------------------------------------------
              // 🔹 CONFIDENTIALITÉ
              // ------------------------------------------------------------
              const Text(
                "Confidentialité",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPast),
              ),
              const SizedBox(height: 10),

              _tile(
                icon: Icons.policy,
                iconColor: Colors.blueGrey,
                title: "Politique de confidentialité",
                subtitle: "Consultez nos règles de protection des données",
                onTap: () => Get.to(() => const PrivacyPolicyPage()),

              ),

              _tile(
                icon: Icons.info_outline_rounded,
                iconColor: Colors.grey,
                title: "Version de l’application",
                subtitle: "v1.0.0",
                onTap: () {},
              ),

              const SizedBox(height: 30),
              Center(
                child: Text(
                  "BantuSchoolPay © ${DateTime.now().year}",
                  style: TextStyle(color: AppColors.primarySoft),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.primary,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: iconColor.withValues(alpha: 0.1),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
