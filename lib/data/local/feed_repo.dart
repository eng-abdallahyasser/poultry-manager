import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poultry_manager/data/models/feed_stock.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';

class FeedRepository extends GetxService {
  static const String _feedBoxName = 'feed_stocks';
  late Box<FeedStock> _feedBox;

  List<FeedStock> get _feedStocks => _feedBox.values.toList();

  List<FeedType> get availableFeedTypes =>
      _feedStocks.map((stock) => stock.feedType).toSet().toList();

  Iterable<FeedStock> get feedStocks =>
      _feedStocks.where((stock) => stock.quantityInKg > 0);

  Future<FeedRepository> init() async {
    try {
      await Hive.initFlutter();

      // Register adapters (generate these first)
      if (!Hive.isAdapterRegistered(FeedStockAdapter().typeId)) {
        Hive.registerAdapter(FeedStockAdapter());
      }
      if (!Hive.isAdapterRegistered(FeedTypeAdapter().typeId)) {
        Hive.registerAdapter(FeedTypeAdapter());
      }

      _feedBox = await Hive.openBox<FeedStock>(_feedBoxName);
      log('FeedRepository initialized with ${_feedStocks.length} stocks');
      return this;
    } catch (e, stackTrace) {
      log(
        'Error initializing FeedRepository',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar('Error', 'Failed to initialize feed storage');
      throw Exception('Failed to initialize FeedRepository: $e');
    }
  }

  Future<void> addFeedStock(FeedStock stock) async {
    try {
      await _feedBox.add(stock);
      log('Added feed stock: ${stock.toString()}');
      Get.snackbar('Success', 'Feed stock added successfully');
    } catch (e, stackTrace) {
      log('Error adding feed stock', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to add feed stock: ${e.toString()}');
      throw Exception('Failed to add feed stock: $e');
    }
  }

  Future<void> consumeFeed(FeedType type, double quantity) async {
    try {
      final stocksToUpdate =
          _feedStocks
              .where(
                (stock) => stock.feedType == type && stock.quantityInKg > 0,
              )
              .toList();

      double remainingQuantity = quantity;

      for (var stock in stocksToUpdate) {
        // Get the key for the stock
        final stockKey = _feedBox.keys.firstWhere(
          (key) => _feedBox.get(key) == stock,
          orElse: () => -1,
        );
        if (remainingQuantity <= 0) break;

        final stockQuantity = stock.quantityInKg;
        if (stockQuantity > remainingQuantity) {
          stock.quantityInKg -= remainingQuantity;
          remainingQuantity = 0;
        } else {
          remainingQuantity -= stockQuantity;
          stock.quantityInKg = 0;
        }

        await _feedBox.put(stockKey, stock);
      }

      if (remainingQuantity > 0) {
        Get.snackbar(
          'Warning',
          'Not enough stock. Remaining needed: $remainingQuantity kg',
        );
      } else {
        Get.snackbar('Success', 'Feed consumed successfully');
      }
    } catch (e, stackTrace) {
      log('Error consuming feed', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to consume feed: ${e.toString()}');
      throw Exception('Failed to consume feed: $e');
    }
  }

  List<String> getCompaniesForFeedType(FeedType feedType) {
    try {
      return _feedStocks
          .where((stock) => stock.feedType == feedType)
          .map((stock) => stock.feedCompany)
          .toSet()
          .toList();
    } catch (e, stackTrace) {
      log(
        'Error getting companies for feed type',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  double getStockQuantity(FeedType type) {
    try {
      return _feedStocks
          .where((stock) => stock.feedType == type)
          .fold(0.0, (sum, stock) => sum + stock.quantityInKg);
    } catch (e, stackTrace) {
      log('Error getting stock quantity', error: e, stackTrace: stackTrace);
      return 0.0;
    }
  }

  double getCostPerKg(FeedType feedType) {
    try {
      final stock = _feedStocks.firstWhere(
        (s) => s.feedType == feedType && s.quantityInKg > 0,
        orElse: () => _feedStocks.firstWhere((s) => s.feedType == feedType),
      );
      return stock.costPerKg;
    } catch (e, stackTrace) {
      log('Error getting cost per kg', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'No price data available for this feed type');
      return 0.0;
    }
  }

  Future<void> updateFeedStock(int key, FeedStock updatedStock) async {
    try {
      await _feedBox.put(key, updatedStock);
      log('Updated feed stock with key $key');
      Get.snackbar('Success', 'Feed stock updated successfully');
    } catch (e, stackTrace) {
      log('Error updating feed stock', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to update feed stock: ${e.toString()}');
      throw Exception('Failed to update feed stock: $e');
    }
  }

  Future<void> deleteFeedStock(int key) async {
    try {
      await _feedBox.delete(key);
      log('Deleted feed stock with key $key');
      Get.snackbar('Success', 'Feed stock deleted successfully');
    } catch (e, stackTrace) {
      log('Error deleting feed stock', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to delete feed stock: ${e.toString()}');
      throw Exception('Failed to delete feed stock: $e');
    }
  }

  Future<void> close() async {
    try {
      await _feedBox.close();
      log('FeedRepository closed successfully');
    } catch (e, stackTrace) {
      log('Error closing FeedRepository', error: e, stackTrace: stackTrace);
      throw Exception('Failed to close FeedRepository: $e');
    }
  }
}
