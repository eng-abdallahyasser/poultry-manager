import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:poultry_manager/data/models/feed_stock.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FeedRepository extends GetxService {
  List<FeedStock> _feedStocks = [];
  late final SharedPreferences _prefs;

  List<FeedType> get availableFeedTypes => 
      _feedStocks.map((stock) => stock.feedType).toSet().toList();

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
    final stocksJson = jsonEncode(_feedStocks.map((stock) => stock.toMap()).toList());
    _prefs.setString('feed_stocks', stocksJson);
  }

  void addFeedStock(FeedStock stock) {
    _feedStocks.add(stock);
    _saveToStorage();
  }

  void consumeFeed(FeedType type, double quantity) {
    // Implement stock consumption logic
    for (var stock in _feedStocks) {
      if (stock.feedType == type && stock.quantity >= quantity) {
        stock.quantity -= quantity;
        if (stock.quantity < 0) stock.quantity = 0; // Prevent negative quantity
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
        .fold(0.0, (sum, stock) => sum + stock.quantity);
  }
}