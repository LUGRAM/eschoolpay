import 'package:get/get.dart';

// Importations des Pages et Controllers
import '../../features/children/bindings/children_binding.dart';
import '../../features/fees/bindings/fees_binding.dart';
import '../../features/fees/pages/cantine_start_page.dart';
import '../../features/fees/pages/payment_fees_page.dart';
import '../../features/fees/pages/payment_page.dart';
import '../../features/fees/pages/payment_registration_page.dart';
import '../../features/fees/pages/services_menu_page.dart';
import '../../features/fees/pages/transport_start_page.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/schools/bindings/school_binding.dart';
import '../../features/splash/pages/splash_page.dart';
import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/auth/pages/welcome_auth_page.dart';
import '../../features/auth/pages/phone_signup_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/children/pages/children_list_page.dart';
import '../../features/children/pages/add_child_page.dart';
import '../../features/fees/pages/registration_start_page.dart';
import '../../features/fees/pages/monthly_fees_star_page.dart';
import '../../features/fees/pages/fees_success_page.dart';

import '../../features/onboarding/controllers/onboarding_controller.dart';
import '../../features/auth/controllers/auth_controller.dart';

// 1. DÉFINITION DES NOMS DE ROUTES
abstract class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const authWelcome = '/auth/welcome';
  static const phoneSignup = '/auth/phone-signup';
  static const home = '/home';
  static const childrenList = '/children';
  static const addChild = '/children/add';
  static const servicesMenu = '/services-menu';
  static const feesStart = '/fees';
  static const feesPreview = '/fees/preview';
  static const feesSuccess = '/fees/success';
  static const childPaymentsHistory = '/fees/history';
  static const faq = '/faq';
  static const monthlyFeesStart = '/fees/monthlyFees';
  static const cantineStart = '/fees/cantine';
  static const transportStart = '/fees/transport';
  static const payment = '/payment';
  static const paymentRegistration = '/payment/registration';
  static const paymentFees = '/payment/fees';
  static const childPaymentHistory  = '/fees/history';


}


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
      name: Routes.authWelcome,
      page: () => const WelcomeAuthPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthController())),
    ),
    GetPage(
      name: Routes.phoneSignup,
      page: () => const PhoneSignupPage(),
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
      binding: FeesBinding(),
    ),
    GetPage(
      name: Routes.feesStart,
      page: () => RegistrationStartPage(),
      bindings:[
        FeesBinding(),
        ChildrenBinding()
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