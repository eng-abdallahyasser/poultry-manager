import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/local/flock_repo.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/adding_flok_screen.dart';

class DashboardController extends GetxController {
  final LocalStorage localStorage = Get.find();

  var income = 0.0.obs;
  var expense = 0.0.obs;
  var profit = 0.0.obs;
  var flocks = <Flock>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // Load data from local storage
    final storedFlocks = localStorage.getFlocks();
    flocks.assignAll(storedFlocks);

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
      localStorage.saveFlocks(flocks);
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
      localStorage.saveFlocks(flocks);
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
    Get.back();
    update();
  }

  
}
