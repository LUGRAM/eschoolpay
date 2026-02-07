import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../children/controllers/children_controller.dart';

// 1. Doit être un StatefulWidget pour gérer le changement de filtre (setState)
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final childrenCtrl = Get.find<ChildrenController>();
  String selectedFilter = "Tous"; // État du filtre

  final Color primaryBlue = const Color(0xFF063D66);

  // Simulation de données diversifiées
  final List<Map<String, dynamic>> mockNotifications = [
    {"type": "payment", "title": "Paiement réussi", "desc": "La mensualité de Février pour Andre a été validée.", "time": "Il y a 2h", "isRead": false, "child": "Andre"},
    {"type": "school", "title": "Réunion Parents", "desc": "L'Institution Immaculée vous invite ce samedi.", "time": "Il y a 5h", "isRead": false, "child": "Marie"},
    {"type": "alert", "title": "Retard de paiement", "desc": "Le délai pour la cantine expire dans 48h.", "time": "2 jours", "isRead": true, "child": "Marie"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(primaryBlue),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // Filtrage logique des données
              itemCount: mockNotifications.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildNotificationItem(mockNotifications[index], primaryBlue);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(Color color) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _filterChip("Tous", color),
          ...childrenCtrl.children.map((child) => _filterChip(child.firstName, color)),
        ],
      ),
    );
  }

  Widget _filterChip(String label, Color color) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif, Color color) {
    IconData icon;
    Color iconColor;

    switch (notif['type']) {
      case 'payment': icon = Icons.check_circle; iconColor = Colors.green; break;
      case 'school': icon = Icons.school; iconColor = Colors.blue; break;
      case 'alert': icon = Icons.warning; iconColor = Colors.orange; break;
      default: icon = Icons.info; iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withValues(alpha:0.1),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(notif['desc'], style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}