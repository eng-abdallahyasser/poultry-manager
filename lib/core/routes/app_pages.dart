import 'package:get/get.dart';
import 'package:poultry_manager/core/bindings/main_binding.dart';
import 'package:poultry_manager/core/routes/routes.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_screen.dart';
import 'package:poultry_manager/modules/splash_screen.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: MainBinding(),
    ),
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    // Add other pages similarly
  ];
}
