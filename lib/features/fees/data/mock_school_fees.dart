/*
import '../models/payment_option_model.dart';
import '../models/discount_model.dart';
import '../models/school_fee_config_model.dart';

const mockSchoolFees = [
  // ==========================================
  // Lycée National Léon Mba – Lycée (sch_1)
  // ==========================================
  SchoolFeeConfigModel(
    schoolId: 'sch_1',
    cycle: 'Lycée',
    paymentOptions: [
      // --- 4e2 : Scolarité ---
      PaymentOptionModel(
        id: 'scol_lm_1m',
        durationInMonths: 1,
        amount: 45000,
      ),
      PaymentOptionModel(
        id: 'scol_lm_3m',
        durationInMonths: 3,
        amount: 120000,
        discount: DiscountModel(
          type: DiscountType.percentage,
          value: 10,
          label: 'Économie 10 %',
        ),
      ),
      PaymentOptionModel(
        id: 'scol_lm_6m',
        durationInMonths: 6,
        amount: 210000,
        discount: DiscountModel(
          type: DiscountType.percentage,
          value: 20,
          label: 'Économie 20 %',
        ),
      ),

      // --- 4e3 : Cantine ---
      PaymentOptionModel(
        id: 'cantine_lm_1m',
        durationInMonths: 1,
        amount: 25000,
      ),
      PaymentOptionModel(
        id: 'cantine_lm_trim',
        durationInMonths: 3,
        amount: 70000,
        discount: DiscountModel(
          type: DiscountType.fixedAmount,
          value: 5000,
          label: 'Réduction Trimestre',
        ),
      ),

      // --- 4e4 : Transport ---
      PaymentOptionModel(
        id: 'trans_lm_zone1',
        durationInMonths: 1,
        amount: 15000, // Tarif mensuel zone A
      ),
    ],
  ),

  // ==========================================
  // CES d’Akébé – Collège (sch_2)
  // ==========================================
  SchoolFeeConfigModel(
    schoolId: 'sch_2',
    cycle: 'Collège',
    paymentOptions: [
      // --- 4e2 : Scolarité ---
      PaymentOptionModel(
        id: 'scol_akebe_1m',
        durationInMonths: 1,
        amount: 30000,
      ),
      PaymentOptionModel(
        id: 'scol_akebe_3m',
        durationInMonths: 3,
        amount: 85000,
        discount: DiscountModel(
          type: DiscountType.fixedAmount,
          value: 5000,
          label: 'Économie 5 000 FCFA',
        ),
      ),

      // --- 4e3 : Cantine ---
      PaymentOptionModel(
        id: 'cantine_akebe_1m',
        durationInMonths: 1,
        amount: 15000,
      ),

      // --- 4e4 : Transport ---
      PaymentOptionModel(
        id: 'trans_akebe_all',
        durationInMonths: 1,
        amount: 10000,
      ),
    ],
  ),
];
 */