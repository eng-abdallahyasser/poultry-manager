import 'package:get/get.dart';
import 'package:poultry_manager/core/bindings/main_binding.dart';
import 'package:poultry_manager/core/routes/routes.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_screen.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: MainBinding(),
    ),
    // Add other pages similarly
  ];
}

