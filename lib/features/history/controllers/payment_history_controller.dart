import 'package:get/get.dart';
import '../models/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  final histories = <PaymentHistory>[].obs;

  void addHistory(PaymentHistory history) {
    histories.insert(0, history); // le plus récent en haut
  }

  String serviceLabel(PaymentServiceType type) {
    switch (type) {
      case PaymentServiceType.inscription:
        return "Inscription scolaire";
      case PaymentServiceType.mensualite:
        return "Frais de scolarité";
      case PaymentServiceType.cantine:
        return "Cantine scolaire";
      case PaymentServiceType.transport:
        return "Transport scolaire";
    }
  }
}
