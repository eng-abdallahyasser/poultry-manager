import 'package:get/get.dart';
import 'package:poultry_manager/core/bindings/main_binding.dart';
import 'package:poultry_manager/core/bindings/stock_binding.dart';
import 'package:poultry_manager/core/routes/routes.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_screen.dart';
import 'package:poultry_manager/modules/dashboard/flok_details_screen.dart';
import 'package:poultry_manager/modules/global_widgets/splash_screen.dart';
import 'package:poultry_manager/modules/stock/add_feed_to_stock_screen.dart';
import 'package:poultry_manager/modules/stock/stock_screen.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.ADD_FEED_TO_STOCK,
      page: () => AddFeedStockScreen(),
      binding: StockBinding(),
    ),
    GetPage(
      name: Routes.Flock_DETAILS,
      page: () => FlockDetailsView( 
        flock: Get.arguments,
      ),
      binding: MainBinding(),
    ),
    
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(
      name: Routes.STOCK,
      page: () => StockScreen(),
      binding: StockBinding(),
    ),
    GetPage(name: Routes.ADD_FEED_STOCK, page: () => AddFeedStockScreen()),
  ];
}
