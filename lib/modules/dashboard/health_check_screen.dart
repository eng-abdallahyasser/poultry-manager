import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/data/models/weight_record.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';

class HealthCheckScreen extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();
  final Flock flock;
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  HealthCheckScreen({super.key, required this.flock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فحص صحة القطيع - ${flock.name}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Health Check Section
              _buildSectionHeader('فحص الصحة العام'),
              _buildHealthCheckItems(),
              const SizedBox(height: 20),

              // Weight Recording Section
              _buildSectionHeader('تسجيل الوزن'),
              _buildWeightInputField(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildNotesField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              
              // Weight History
              _buildSectionHeader('سجل الأوزان'),
              _buildWeightHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildHealthCheckItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildCheckItem('الحالة العامة', 'جيدة', 'سيئة'),
            const Divider(),
            _buildCheckItem('النشاط', 'طبيعي', 'خامل'),
            const Divider(),
            _buildCheckItem('الشهية', 'جيدة', 'ضعيفة'),
            const Divider(),
            _buildCheckItem('الريش', 'ناعم', 'منفوش'),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String label, String goodLabel, String badLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            _buildCheckOption(goodLabel, Colors.green),
            const SizedBox(width: 8),
            _buildCheckOption(badLabel, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckOption(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color)),
    );
  }

  Widget _buildWeightInputField() {
    return TextFormField(
      controller: _weightController,
      decoration: const InputDecoration(
        labelText: 'الوزن (جرام)',
        border: OutlineInputBorder(),
        suffixText: 'جرام',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'الرجاء إدخال الوزن';
        if (int.tryParse(value) == null) return 'الرجاء إدخال رقم صحيح';
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != _selectedDate) {
          _selectedDate = picked;
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'تاريخ القياس',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'ملاحظات (اختياري)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'حفظ البيانات',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildWeightHistory() {
    if (flock.weightRecords.isEmpty) {
      return const Center(child: Text('لا توجد سجلات وزن سابقة'));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ...flock.weightRecords.map((record) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.monitor_weight, color: Colors.blue),
                  title: Text('${record.weightInGrams} جرام'),
                  subtitle: Text('${record.date.day}/${record.date.month}/${record.date.year}'),
                  trailing: Text('${record.weightInKg.toStringAsFixed(2)} كجم'),
                ),
                const Divider(),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newRecord = WeightRecord(
        date: _selectedDate,
        weightInGrams: int.parse(_weightController.text),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Update the flock - you'll need to implement this in your controller
      final updatedFlock = flock.copyWith(
        weightRecords: [...flock.weightRecords, newRecord],
      );
      controller.saveAndNavigateToFlockDetails(updatedFlock);
      
    }
  }
}