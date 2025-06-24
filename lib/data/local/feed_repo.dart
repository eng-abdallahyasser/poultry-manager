import 'dart:developer';

import 'package:get/get.dart';
import 'package:poultry_manager/data/models/feed_stock.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FeedRepository extends GetxService {
  List<FeedStock> _feedStocks = [];
  late final SharedPreferences _prefs;

  List<FeedType> get availableFeedTypes =>
      _feedStocks.map((stock) => stock.feedType).toSet().toList();

  Iterable<FeedStock> get feedStocks =>
      _feedStocks.where((stock) => stock.quantityInKg > 0);

  Future<FeedRepository> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFromStorage();
    return this;
  }

  void _loadFromStorage() {
    final stocksJson = _prefs.getString('feed_stocks');
    if (stocksJson != null) {
      final List<dynamic> jsonList = jsonDecode(stocksJson);
      _feedStocks = jsonList.map((json) => FeedStock.fromMap(json)).toList();
    }
  }

  void _saveToStorage() {
    final stocksJson = jsonEncode(
      _feedStocks.map((stock) => stock.toMap()).toList(),
    );
    _prefs.setString('feed_stocks', stocksJson);
  }

  void addFeedStock(FeedStock stock) {
    _feedStocks.add(stock);
    try {
      _saveToStorage();
      log('Saved data: ${_prefs.getString('feed_stocks')}');
      Get.snackbar('Success', 'Flocks saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save flocks: $e');
    }
  }

  void consumeFeed(FeedType type, double quantity) {
    // Implement stock consumption logic
    for (var stock in _feedStocks) {
      if (stock.feedType == type && stock.quantityInKg >= quantity) {
        stock.quantityInKg -= quantity;
        if (stock.quantityInKg < 0)
          stock.quantityInKg = 0; // Prevent negative quantity
        _saveToStorage();
        return;
      }
    }

    _saveToStorage();
  }

  List<String> getCompaniesForFeedType(FeedType feedType) {
    return _feedStocks
        .where((stock) => stock.feedType == feedType)
        .map((stock) => stock.feedCompany)
        .toSet()
        .toList();
  }

  getStockQuantity(FeedType type) {
    return _feedStocks
        .where((stock) => stock.feedType == type)
        .fold(0.0, (sum, stock) => sum + stock.quantityInKg);
  }

  getCostPerKg(FeedType feedType) {
    final stock = _feedStocks.firstWhere((s) => s.feedType == feedType);
    log('Cost per kg for $feedType: ${stock.costPerKg}');
    return stock.costPerKg;
  }
}
