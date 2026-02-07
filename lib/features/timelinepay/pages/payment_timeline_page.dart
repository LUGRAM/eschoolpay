import 'package:flutter/material.dart';

class PaymentTimelinePage extends StatelessWidget {
  const PaymentTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF063D66);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text("Suivi de Scolarité",
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // En-tête informatif
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Suivez l'état des services pour l'année 2024-2025",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildTimelineStep(
                  title: "Frais d'inscription",
                  date: "Payé le 05 Sept 2024",
                  status: TimelineStatus.completed,
                  color: primaryBlue,
                ),
                _buildTimelineStep(
                  title: "Scolarité - 1er Trimestre",
                  date: "Payé le 15 Oct 2024",
                  status: TimelineStatus.completed,
                  color: primaryBlue,
                ),
                _buildTimelineStep(
                  title: "Cantine - Décembre",
                  date: "Échéance : 05 Déc 2024",
                  status: TimelineStatus.inProgress,
                  color: primaryBlue,
                ),
                _buildTimelineStep(
                  title: "Scolarité - 2ème Trimestre",
                  date: "À prévoir : Janvier 2025",
                  status: TimelineStatus.upcoming,
                  color: primaryBlue,
                ),
                _buildTimelineStep(
                  title: "Frais d'Examen / Fin d'année",
                  date: "Mai 2025",
                  status: TimelineStatus.upcoming,
                  color: primaryBlue,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String date,
    required TimelineStatus status,
    required Color color,
    bool isLast = false
  }) {
    IconData icon;
    Color circleColor;
    Color textColor;

    switch (status) {
      case TimelineStatus.completed:
        icon = Icons.check_circle;
        circleColor = Colors.green;
        textColor = Colors.black87;
        break;
      case TimelineStatus.inProgress:
        icon = Icons.pending_actions;
        circleColor = Colors.orange;
        textColor = Colors.black87;
        break;
      case TimelineStatus.upcoming:
        icon = Icons.radio_button_unchecked;
        circleColor = Colors.grey.shade400;
        textColor = Colors.grey;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          // La ligne verticale et l'icône
          Column(
            children: [
              Icon(icon, color: circleColor, size: 24),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: status == TimelineStatus.completed ? Colors.green : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          // La carte d'information
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: status == TimelineStatus.inProgress
                    ? Border.all(color: Colors.orange.withValues(alpha:0.5), width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha:0.02), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum TimelineStatus { completed, inProgress, upcoming }