import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/dialy_feeding.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';


class DailyFeedingForm extends StatefulWidget {
  final Function(DailyFeeding) onSave;

  const DailyFeedingForm({super.key, required this.onSave});

  @override
  State<DailyFeedingForm> createState() => _DailyFeedingFormState();
}

class _DailyFeedingFormState extends State<DailyFeedingForm> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _costController = TextEditingController();
  String? _selectedCompany;
  FeedType? _selectedFeedType;
  DateTime _selectedDate = DateTime.now();
  final _notesController = TextEditingController();

  final List<String> _feedCompanies = ['شركة الأعلاف 1', 'شركة الأعلاف 2', 'شركة أخرى'];
  final List<FeedType> _feedTypes = FeedType.values;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDatePicker(),
            const SizedBox(height: 16),
            _buildFeedCompanyDropdown(),
            const SizedBox(height: 16),
            _buildFeedTypeDropdown(),
            const SizedBox(height: 16),
            // _buildQuantityField(),
            // const SizedBox(height: 16),
            // _buildCostField(),
            // const SizedBox(height: 16),
            // _buildNotesField(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'تاريخ التغذية',
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      controller: TextEditingController(text: _selectedDate.toLocal().toString().split(' ')[0]),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      validator: (value) => value == null || value.isEmpty ? 'الرجاء اختيار تاريخ' : null,
    );
  }

  Widget _buildFeedCompanyDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'شركة الأعلاف',
        border: OutlineInputBorder(),
      ),
      value: _selectedCompany,
      items: _feedCompanies.map((String company) {
        return DropdownMenuItem<String>(
          value: company,
          child: Text(company),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCompany = newValue;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار شركة الأعلاف' : null,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: const Text('حفظ'),
    );
  }

  Widget _buildFeedTypeDropdown() {
    return DropdownButtonFormField<FeedType>(
      decoration: InputDecoration(
        labelText: 'نوع العلف',
        border: OutlineInputBorder(),
      ),
      value: _selectedFeedType,
      items: _feedTypes.map((FeedType type) {
        return DropdownMenuItem<FeedType>(
          value: type,
          child: Text(type.arabicName),
        );
      }).toList(),
      onChanged: (FeedType? newValue) {
        setState(() {
          _selectedFeedType = newValue;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار نوع العلف' : null,
    );
  }

  // ... other form field builders ...

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedCompany != null &&
        _selectedFeedType != null) {
      final feeding = DailyFeeding(
        date: _selectedDate,
        quantity: double.parse(_quantityController.text),
        feedCompany: _selectedCompany!,
        feedType: _selectedFeedType!,
        notes: _notesController.text,
        costPerKg: double.parse(_costController.text),
      );
      widget.onSave(feeding);
      Get.back();
    }
  }
}