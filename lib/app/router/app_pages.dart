import 'package:bantuschoolpay/app/binding/auth_binding.dart';
import 'package:get/get.dart';

// Importations des Pages et Controllers
import '../../features/auth/pages/phone_signin_page.dart';
import '../../features/children/bindings/children_binding.dart';
import '../../features/fees/bindings/fees_binding.dart';
import '../../features/fees/pages/cantine_start_page.dart';
import '../../features/fees/pages/payment_page.dart';
import '../../features/fees/pages/services_menu_page.dart';
import '../../features/fees/pages/transport_start_page.dart';
import '../../features/history/pages/history_page.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/pages/edit_sheet_page.dart';
import '../../features/schools/bindings/school_binding.dart';
import '../../features/splash/pages/splash_page.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/auth/pages/phone_signup_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/children/pages/children_list_page.dart';
import '../../features/children/pages/add_child_page.dart';
import '../../features/fees/pages/registration_start_page.dart';
import '../../features/fees/pages/monthly_fees_star_page.dart';
import '../../features/fees/pages/fees_success_page.dart';
import '../../features/onboarding/controllers/onboarding_controller.dart';
import '../../features/history/pages/payment_detail_page.dart';


// 1. DÉFINITION DES NOMS DE ROUTES
import 'package:bantuschoolpay/app/router/routes.dart';

// 2. CONFIGURATION DES PAGES ET BINDINGS
class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => OnboardingController())),
    ),
    GetPage(
      name: Routes.editSheet,
      page: () => const EditProfileSheet(),
      binding: BindingsBuilder(() => Get.lazyPut(() => OnboardingController())),
    ),
    GetPage(
      name: Routes.phoneSignup,
      page: () => const PhoneSignupPage(),
    ),
    GetPage(
      name: Routes.phoneSignin,
      page: () => const PhoneSigninPage(),
    ),
    GetPage(
      name: Routes.childrenList,
      page: () => const ChildrenListPage(),
      binding: ChildrenBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const ESchoolHomePage(),
      bindings: [
        AuthBinding(),
        ChildrenBinding(),
        FeesBinding(),
        ProfileBinding()
      ],
    ),
    GetPage(
      name: Routes.addChild,
      page: () => const AddChildPage(),
      binding: SchoolsBinding(),
    ),
    GetPage(
      name: Routes.servicesMenu,
      page: () => const ServicesMenuPage(),
      bindings: [
        ChildrenBinding(),
        FeesBinding()]
    ),
    GetPage(
      name: Routes.feesStart,
      page: () => RegistrationStartPage(),
      bindings:[
        FeesBinding(),
        ChildrenBinding(),
        SchoolsBinding()
      ],
    ),
    GetPage(
      name: Routes.feesSuccess,
      page: () => const FeesSuccessPage(),
    ),

    GetPage(
      name: Routes.monthlyFeesStart,
      page: () => const MonthlyFeesStartPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.cantineStart,
      page: () => const CantineStartPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.transportStart,
      page: () => const TransportStartPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.payment,
      page: () => const PaymentPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.paymentDetail,
      page: () => const PaymentDetailPage(),
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryPage(),
    ),


    /*
    GetPage(
      name: Routes.feesPreview,
      page: () => const FeesPreviewPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.childPaymentsHistory,
      page: () => const ChildPaymentsHistoryPage(),
      binding: FeesBinding(),
    GetPage(
      name: Routes.paymentRegistration,
      page: () => const PaymentRegistrationPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.paymentFees,
      page: () => const PaymentFeesPage(),
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.childPaymentsHistory,
      page: () => const ChildPaymentsHistoryPage(),
      binding: FeesBinding(),
    ),*/
  ];
}