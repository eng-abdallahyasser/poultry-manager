import 'package:get/get.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Add other controllers
  }
}