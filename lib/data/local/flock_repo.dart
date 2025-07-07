import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poultry_manager/data/models/flok.dart';



class FlockRepository extends GetxService {
  static const String _flockBoxName = 'flocks';
  late Box<Flock> _flockBox;

  // Initialize Hive and open boxes
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      
      // Register adapters (you'll need to generate these)
      if (!Hive.isAdapterRegistered(FlockAdapter().typeId)) {
        Hive.registerAdapter(FlockAdapter());
      }
      
      _flockBox = await Hive.openBox<Flock>(_flockBoxName);
      log('Hive initialized successfully');
    } catch (e, stackTrace) {
      log('Error initializing Hive', error: e, stackTrace: stackTrace);
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  // Save all flocks (replaces existing data)
  Future<void> saveFlocks(List<Flock> flocks) async {
    try {
      await _flockBox.clear();
      await _flockBox.addAll(flocks);
      log('Saved ${flocks.length} flocks to Hive');
      Get.snackbar('Success', 'Flocks saved successfully');
    } catch (e, stackTrace) {
      log('Error saving flocks', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to save flocks: ${e.toString()}');
      throw Exception('Failed to save flocks: $e');
    }
  }

  // Get all flocks
  List<Flock> getFlocks() {
    try {
      final flocks = _flockBox.values.toList();
      log('Retrieved ${flocks.length} flocks from Hive');
      return flocks;
    } catch (e, stackTrace) {
      log('Error getting flocks', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to load flocks: ${e.toString()}');
      throw Exception('Failed to load flocks: $e');
    }
  }

  // Add a single flock
  Future<void> addFlock(Flock flock) async {
    try {
      await _flockBox.add(flock);
      log('Added flock: ${flock.toString()}');
      Get.snackbar('Success', 'Flock added successfully');
    } catch (e, stackTrace) {
      log('Error adding flock', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to add flock: ${e.toString()}');
      throw Exception('Failed to add flock: $e');
    }
  }

  // Update a flock by key
  Future<void> updateFlock(int key, Flock flock) async {
    try {
      await _flockBox.put(key, flock);
      log('Updated flock with key $key: ${flock.toString()}');
      Get.snackbar('Success', 'Flock updated successfully');
    } catch (e, stackTrace) {
      log('Error updating flock', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to update flock: ${e.toString()}');
      throw Exception('Failed to update flock: $e');
    }
  }

  // Delete a flock by key
  Future<void> deleteFlock(int key) async {
    try {
      await _flockBox.delete(key);
      log('Deleted flock with key $key');
      Get.snackbar('Success', 'Flock deleted successfully');
    } catch (e, stackTrace) {
      log('Error deleting flock', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to delete flock: ${e.toString()}');
      throw Exception('Failed to delete flock: $e');
    }
  }

  // Clear all flocks
  Future<void> clearAllFlocks() async {
    try {
      await _flockBox.clear();
      log('Cleared all flocks');
      Get.snackbar('Success', 'All flocks cleared successfully');
    } catch (e, stackTrace) {
      log('Error clearing flocks', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to clear flocks: ${e.toString()}');
      throw Exception('Failed to clear flocks: $e');
    }
  }

  // Close the Hive box when done
  Future<void> close() async {
    try {
      await _flockBox.close();
      log('Hive box closed successfully');
    } catch (e, stackTrace) {
      log('Error closing Hive box', error: e, stackTrace: stackTrace);
      throw Exception('Failed to close Hive box: $e');
    }
  }
}