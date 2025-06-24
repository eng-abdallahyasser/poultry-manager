import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/feed_stock.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';
import 'package:poultry_manager/modules/stock/add_feed_stock_controller.dart';

class AddFeedStockScreen extends StatelessWidget {
  const AddFeedStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddFeedStockController());

    return Scaffold(
      appBar: AppBar(title: const Text('إضافة علف جديد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                children: [
                  // Feed Type Dropdown
                  Expanded(child: Obx(() => _buildFeedTypeDropdown(controller))),
                  const SizedBox(width: 16),

                  // Company Dropdown
                  Expanded(child: Obx(() => _buildCompanyDropdown(controller))),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  // Measurement Unit
                  Expanded(child: Obx(() => _buildMeasurementUnitDropdown(controller))),
                  const SizedBox(width: 16),

                  // Quantity Field
                  Expanded(child: _buildQuantityField(controller)),
                ],
              ),

              const SizedBox(height: 16),

              // Total Cost Field
              _buildTotalCostField(controller),
              const SizedBox(height: 16),

              // Calculated Cost Per Kg
              Obx(() => _buildCostPerKgDisplay(controller)),
              const SizedBox(height: 16),

              // Date Pickers
              Obx(
                () => _buildDatePicker(
                  controller,
                  'تاريخ الشراء',
                  controller.selectedDate.value,
                  (date) => controller.selectedDate.value = date,
                ),
              ),
              const SizedBox(height: 16),

              Obx(
                () => _buildDatePicker(
                  controller,
                  'تاريخ الانتهاء (اختياري)',
                  controller.expiryDate.value,
                  (date) => controller.expiryDate.value = date,
                  isOptional: true,
                ),
              ),
              const SizedBox(height: 16),

              // Batch Number
              _buildBatchNumberField(controller),
              const SizedBox(height: 16),

              // Notes
              _buildNotesField(controller),
              const SizedBox(height: 24),

              // Submit Button
              _buildSubmitButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedTypeDropdown(AddFeedStockController controller) {
    return DropdownButtonFormField<FeedType>(
      value: controller.selectedFeedType.value,
      items:
          FeedType.values.map((type) {
            return DropdownMenuItem<FeedType>(
              value: type,
              child: Text(type.arabicName),
            );
          }).toList(),
      onChanged: (type) {
        controller.selectedFeedType.value = type!;
      },
      decoration: const InputDecoration(
        labelText: 'نوع العلف',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCompanyDropdown(AddFeedStockController controller) {
    return DropdownButtonFormField<String>(
      value: controller.selectedCompany.value,
      items:
          controller.companies.map((company) {
            return DropdownMenuItem<String>(
              value: company,
              child: Text(company),
            );
          }).toList(),
      onChanged: (company) {
        controller.selectedCompany.value = company!;
      },
      decoration: const InputDecoration(
        labelText: 'شركة التوريد',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildMeasurementUnitDropdown(AddFeedStockController controller) {
    return DropdownButtonFormField<FeedMeasurementUnit>(
      value: controller.selectedUnit.value,
      items:
          FeedMeasurementUnit.values.map((unit) {
            return DropdownMenuItem<FeedMeasurementUnit>(
              value: unit,
              child: Text(unit.arabicName),
            );
          }).toList(),
      onChanged: (unit) {
        controller.selectedUnit.value = unit!;
        controller.calculateCostPerKg();
      },
      decoration: const InputDecoration(
        labelText: 'وحدة القياس',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildQuantityField(AddFeedStockController controller) {
    return TextFormField(
      controller: controller.quantityController,
      onChanged: (_) => controller.calculateCostPerKg(),
      decoration: InputDecoration(
        labelText: 'الكمية',
        border: const OutlineInputBorder(),
        suffixText: controller.selectedUnit.value.arabicName,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'الرجاء إدخال الكمية';
        if (double.tryParse(value) == null) return 'الرجاء إدخال رقم صحيح';
        return null;
      },
    );
  }

  Widget _buildTotalCostField(AddFeedStockController controller) {
    return TextFormField(
      controller: controller.totalCostController,
      onChanged: (_) => controller.calculateCostPerKg(),
      decoration: const InputDecoration(
        labelText: 'التكلفة الإجمالية',
        border: OutlineInputBorder(),
        suffixText: 'جنية',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'الرجاء إدخال التكلفة';
        if (double.tryParse(value) == null) return 'الرجاء إدخال رقم صحيح';
        return null;
      },
    );
  }

  Widget _buildCostPerKgDisplay(AddFeedStockController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Text(
            'سعر الكيلو: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${controller.costPerKg.value.toStringAsFixed(2)} جنية/كجم',
            style: const TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    AddFeedStockController controller,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected, {
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                  : isOptional
                  ? 'غير محدد'
                  : 'الرجاء اختيار التاريخ',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchNumberField(AddFeedStockController controller) {
    return TextFormField(
      controller: controller.batchNumberController,
      decoration: const InputDecoration(
        labelText: 'رقم الدفعة (اختياري)',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNotesField(AddFeedStockController controller) {
    return TextFormField(
      controller: controller.notesController,
      decoration: const InputDecoration(
        labelText: 'ملاحظات (اختياري)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSubmitButton(AddFeedStockController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'حفظ العلف',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
