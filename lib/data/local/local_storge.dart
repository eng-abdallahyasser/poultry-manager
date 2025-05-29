import 'dart:developer';

import 'package:get/get.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage extends GetxService {
  late SharedPreferences _prefs;

  Future<LocalStorage> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveFlocks(List<Flock> flocks) async {
    try {
      final flocksJson = jsonEncode(
        flocks.map((flock) => flock.toMap()).toList(),
      );
      _prefs.setString('flocks', flocksJson);
      log('Saved data: ${_prefs.getString('flocks')}');
      Get.snackbar('Success', 'Flocks saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save flocks: $e');
    }
  }

  List<Flock> getFlocks() {
    final flocksJson = _prefs.getString('flocks');
    if (flocksJson != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(flocksJson);
        return jsonList.map((json) => Flock.fromMap(json)).toList();
      } catch (e) {
        Get.snackbar('Error', 'Failed to load flocks: $e');
        return [];
      }
    }
    return [];
  }

  // Add other local storage methods as needed
}
