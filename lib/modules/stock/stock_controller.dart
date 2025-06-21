import 'package:get/get.dart';
import 'package:poultry_manager/data/local/feed_repo.dart';
import 'package:poultry_manager/data/models/feed_stock.dart';
import 'package:poultry_manager/data/models/medicine_stock.dart';
import 'package:poultry_manager/data/models/vaccine_stock.dart';

class StockController extends GetxController {
  final FeedRepository feedRepo = Get.find();
  
  // We'll add medicine and vaccine repositories later
  final RxList<FeedStock> feedStocks = <FeedStock>[].obs;
  final RxList<MedicineStock> medicineStocks = <MedicineStock>[].obs;
  final RxList<VaccineStock> vaccineStocks = <VaccineStock>[].obs;

  StockController(FeedRepository find);

  @override
  void onInit() {
    super.onInit();
    loadStocks();
  }

  void loadStocks() {
    feedStocks.assignAll(feedRepo.feedStocks);
    // Load medicines and vaccines here when repositories are ready
  }

  double getTotalFeedStock() {
    return feedStocks.fold(0, (sum, stock) => sum + stock.quantity);
  }

  // Similar methods for medicines and vaccines
}