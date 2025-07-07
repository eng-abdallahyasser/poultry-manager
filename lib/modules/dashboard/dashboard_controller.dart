import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/local/flock_repo.dart';
import 'package:poultry_manager/data/models/doctor_check.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/data/models/weight_record.dart';
import 'package:poultry_manager/modules/dashboard/adding_flok_screen.dart';

class DashboardController extends GetxController {
  final flockRepo = FlockRepository();

  var income = 0.0.obs;
  var expense = 0.0.obs;
  var profit = 0.0.obs;
  var flocks = <Flock>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    try {
      // Initialize the flock repository
      await flockRepo.init();
      final storedFlocks = flockRepo.getFlocks();
      flocks.assignAll(storedFlocks);
    } catch (e) {
      log('Initialization error: $e');
    }

    calculateSummary();
  }

  void calculateSummary() {
    // Calculate income, expense, and profit
    double totalIncome = 0;
    double totalExpense = 0;

    for (var flock in flocks) {
      totalIncome += flock.income;
      totalExpense += flock.expense;
    }

    income.value = totalIncome;
    expense.value = totalExpense;
    profit.value = totalIncome - totalExpense;
  }

  void navigateToAddFlock() async {
    final newFlock = await Get.to<Flock>(() => AddFlockView());
    if (newFlock != null) {
      flocks.add(newFlock);
      await flockRepo.saveFlocks(flocks);
      calculateSummary();
      Get.snackbar(
        'نجاح',
        'تم إضافة القطيع بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void saveAndNavigateToFlockDetails(Flock updatedFlock) async {
    final index = flocks.indexWhere((f) => f.id == updatedFlock.id);
    if (index != -1) {
      flocks[index] = updatedFlock;
      await flockRepo.saveFlocks(flocks);
      calculateSummary();
      Get.snackbar(
        'نجاح',
        'تم تحديث القطيع بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        'لم يتم العثور على القطيع المحدد',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    Get.back(closeOverlays: true);
  }

  void addDailyCheck(String id, WeightRecord weightRecord) async {
    final index = flocks.indexWhere((f) => f.id == id);
    if (index != -1) {
      flocks[index].weightRecords.add(weightRecord);
      await flockRepo.saveFlocks(flocks);
      calculateSummary();
      Get.snackbar(
        'نجاح',
        'تم إضافة الفحص اليومي بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        'لم يتم العثور على القطيع المحدد',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    Get.back(closeOverlays: true);
  }

  void addDoctorCheck(String flockId, DoctorCheck check) async {
    final flockIndex = flocks.indexWhere((f) => f.id == flockId);
    if (flockIndex != -1) {
      final updatedFlock = flocks[flockIndex].copyWith(
        doctorChecks: [...flocks[flockIndex].doctorChecks, check],
      );
      flocks[flockIndex] = updatedFlock;
      await flockRepo.saveFlocks(flocks);

      update();
    }
    Get.back(closeOverlays: true);
  }
}
