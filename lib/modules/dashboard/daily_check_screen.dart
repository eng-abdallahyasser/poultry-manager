import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/data/models/weight_record.dart';
import 'package:poultry_manager/modules/dashboard/doctor_check_screen.dart';
import 'package:poultry_manager/modules/global_widgets/custom_btn.dart';

class DailyCheckScreen extends StatefulWidget {
  final Flock flock;
  final Function(WeightRecord) onSave;

  const DailyCheckScreen({super.key, required this.onSave, required this.flock});

  @override
  State<DailyCheckScreen> createState() => _DailyCheckScreenState();
}

class _DailyCheckScreenState extends State<DailyCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  final List<int> _sampleWeights = []; // Local state only
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفحص اليومي - قياس الوزن'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Weight Input Section
              _buildWeightInputSection(),
              const SizedBox(height: 20),

              // Sample Weights Display
              _buildSampleWeightsList(),
              const SizedBox(height: 20),

              // Date Picker
              _buildDatePicker(),
              const SizedBox(height: 20),

              // Notes
              _buildNotesField(),
              const SizedBox(height: 30),

              _buildNavigatToDoctorCheck() ,

              // Action Buttons
              CustomBtn(title: ' حفظ متوسط الاوزان', onTap: _submitForm),
            ],
          ),
        ),
      ),
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
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
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

  Widget _buildWeightInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'وزن العينة (جرام)',
                border: OutlineInputBorder(),
                suffixText: 'جرام',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'الرجاء إدخال الوزن';
                if (int.tryParse(value) == null) return 'الرجاء إدخال رقم صحيح';
                return null;
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('حفظ العينة'),
              onPressed: _addSampleWeight,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleWeightsList() {
    if (_sampleWeights.isEmpty) {
      return const Center(child: Text('لا توجد عينات مسجلة بعد'));
    }

    final avg = _calculateAverageWeight();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('عينة \u200e${_sampleWeights.length} '),

                const Text(
                  ' : العدد ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('كجم \u200e${(avg / 1000).toStringAsFixed(2)} '),

                const Text(
                  ' :المتوسط',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _sampleWeights
                      .map(
                        (weight) => Chip(
                          label: Text('$weight جم'),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeSampleWeight(weight),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ... keep other methods (_buildDatePicker, _buildNotesField, _buildActionButtons) the same ...

  void _addSampleWeight() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _sampleWeights.add(int.parse(_weightController.text));
        _weightController.clear();
      });
    }
  }

  void _removeSampleWeight(int weight) {
    setState(() {
      _sampleWeights.remove(weight);
    });
  }

  int _calculateAverageWeight() {
    if (_sampleWeights.isEmpty) return 0;
    return (_sampleWeights.reduce((a, b) => a + b) / _sampleWeights.length)
        .round();
  }

  void _submitForm() {
    if (_sampleWeights.isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء إدخال عينات الوزن أولاً',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final record = WeightRecord(
      date: _selectedDate,
      weightInGrams: _calculateAverageWeight(),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    widget.onSave(record);
    Get.back();
    Get.snackbar(
      'تم الحفظ',
      'تم تسجيل الوزن المتوسط بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Widget _buildNavigatToDoctorCheck() {
    return ElevatedButton(
      onPressed: () {
        Get.to(() =>DoctorCheckScreen(flockId: widget.flock.id,));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: const Text('الانتقال إلى فحص الطبيب'),
    );
  }
}
