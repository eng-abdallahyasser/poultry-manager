import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/feed_stock.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';
import 'package:poultry_manager/modules/stock/stock_controller.dart';

class AddFeedStockController extends GetxController {
  final StockController _stockController = Get.find();

  // Form state
  final formKey = GlobalKey<FormState>();
  final quantityController = TextEditingController();
  final totalCostController = TextEditingController();
  final batchNumberController = TextEditingController();
  final notesController = TextEditingController();

  // Selected values
  var selectedFeedType = FeedType.badi.obs;
  var selectedCompany = 'شركة الأعلاف 1'.obs;
  var selectedUnit = FeedMeasurementUnit.bag50kg.obs;
  var selectedDate = DateTime.now().obs;
  var expiryDate = Rxn<DateTime>();
  var costPerKg = 0.0.obs;

  final companies = ['شركة الأعلاف 1', 'شركة الأعلاف 2', 'شركة أخرى'];

  void calculateCostPerKg() {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final total = double.tryParse(totalCostController.text) ?? 0;

    if (quantity > 0 && total > 0) {
      costPerKg.value = total / (quantity * selectedUnit.value.kgEquivalent);
    } else {
      costPerKg.value = 0;
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      final newStock = FeedStock(
        feedCompany: selectedCompany.value,
        feedType: selectedFeedType.value,
        quantityInKg:
            double.parse(quantityController.text) *
            selectedUnit.value.kgEquivalent,
        totalCost: double.parse(totalCostController.text),
        purchaseDate: selectedDate.value,
        expiryDate: expiryDate.value,
        batchNumber:
            batchNumberController.text.isNotEmpty
                ? batchNumberController.text
                : null,
      );
      Get.back();
      _stockController.addFeedStock(newStock);

      Get.snackbar(
        'تم الحفظ',
        'تمت إضافة العلف بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    quantityController.dispose();
    totalCostController.dispose();
    batchNumberController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
