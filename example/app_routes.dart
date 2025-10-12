import 'package:get/get.dart';
import 'package:template/pages/address/address_page.dart';
import 'package:template/pages/init/init_page.dart';
import 'package:template/pages/intro/intro_page.dart';

class AppRoutes {
  static String intro = '/';

  // AUTHENTICATIONS
  static String signUp = '/intro';
  static String signIn = '/home';
  static String forgetPassword = '/address';
  static String otp = '/otp';

  static String signIn = '/sign-in';
  static String signOut = '/sign-out';
  static String logout = '/logout';
  
  static List<GetPage> routes = [
    // INTRO PAGE
    GetPage(name: AppRoutes.intro, page: () => const IntroPage()),

    // HOME PAGE
    GetPage(name: AppRoutes.home, page: () => const InitPage()),
    GetPage(name: AppRoutes.address, page: () => const AddressPage()),
    GetPage(name: AppConstants.signIn, page: () => const EmptyPage()),
    GetPage(name: AppConstants.signOut, page: () => const EmptyPage()),
    GetPage(name: AppConstants.logout, page: () => const EmptyPage()),

  ];
}
