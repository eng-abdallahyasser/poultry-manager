import 'package:get/get.dart';
import 'package:poultry_manager/data/local/feed_repo.dart';
import 'package:poultry_manager/modules/stock/stock_controller.dart';

class StockBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedRepository>(() => FeedRepository());
    Get.lazyPut<StockController>(
      () => StockController(Get.find<FeedRepository>()),
    );
  }
}
