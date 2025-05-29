import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/flok.dart';

class AddFlockView extends StatefulWidget {
  const AddFlockView({super.key});

  @override
  State<AddFlockView> createState() => _AddFlockViewState();
}

class _AddFlockViewState extends State<AddFlockView> {
  final _formKey = GlobalKey<FormState>();
  final List<String> birdTypes = [
    'فراخ بلدي',
    'فراخ بيضة تسمين',
    'فراخ بيضة بياض',
  ];
  final List<String> flockTypes = ['السلالة 1', 'السلالة 2', 'السلالة 3'];
  final List<String> fortifications = ['التحصين 1', 'التحصين 2', 'التحصين 3'];
  final List<String> paymentMethods = ['كاش', 'أجل'];

  String selectedBirdType = '';
  String flockName = '';
  String count = '';
  String selectedFlockType = '';
  String supplier = '';
  List<String> selectedFortifications = [];
  String oneBirdCost = '';
  String paidTo = '';
  String selectedPaymentMethod = '';
  DateTime selectedDate = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة قطيع جديد'),
        backgroundColor: Colors.blue, // Blue color
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveFlock),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bird Type Dropdown
              _buildDropdownFormField(
                label: 'نوع الطيور',
                value: selectedBirdType,
                items: birdTypes,
                onChanged: (value) {
                  setState(() {
                    selectedBirdType = value!;
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'الرجاء اختيار نوع الطيور' : null,
              ),

              // Flock Name
              _buildTextFormField(
                label: 'اسم القطيع',
                onSaved: (value) => flockName = value!,
                validator:
                    (value) =>
                        value!.isEmpty ? 'الرجاء إدخال اسم القطيع' : null,
              ),

              // Count
              _buildTextFormField(
                label: 'العدد',
                keyboardType: TextInputType.number,
                onSaved: (value) => count = value!,
                validator:
                    (value) => value!.isEmpty ? 'الرجاء إدخال العدد' : null,
              ),

              // Flock Type Dropdown
              _buildDropdownFormField(
                label: 'نوع القطيع',
                value: selectedFlockType,
                items: flockTypes,
                onChanged: (value) {
                  setState(() {
                    selectedFlockType = value!;
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'الرجاء اختيار نوع القطيع' : null,
              ),

              // Supplier
              _buildTextFormField(
                label: 'شركة المورد',
                onSaved: (value) => supplier = value!,
                validator:
                    (value) =>
                        value!.isEmpty ? 'الرجاء إدخال شركة المورد' : null,
              ),

              // Fortifications (Multiple Selection)
              _buildMultiSelectFormField(),

              // Expense
              _buildTextFormField(
                label: 'المصروفات',
                keyboardType: TextInputType.number,
                onSaved: (value) => oneBirdCost = value!,
                validator:
                    (value) => value!.isEmpty ? 'الرجاء إدخال المصروفات' : null,
              ),

              // Paid To
              _buildTextFormField(
                label: 'دفع إلى',
                onSaved: (value) => paidTo = value!,
                validator:
                    (value) =>
                        value!.isEmpty ? 'الرجاء إدخال اسم المستلم' : null,
              ),

              // Payment Method Dropdown
              _buildDropdownFormField(
                label: 'طريقة الدفع',
                value: selectedPaymentMethod,
                items: paymentMethods,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'الرجاء اختيار طريقة الدفع' : null,
              ),

              // Date Picker
              _buildDatePickerFormField(),

              // Notes
              _buildTextFormField(
                label: 'ملاحظات',
                maxLines: 3,
                onSaved: (value) => notes = value ?? '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    TextInputType? keyboardType,
    int? maxLines,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String?> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        value: value.isEmpty ? null : value,
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildMultiSelectFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('التحصينات', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children:
                fortifications.map((fortification) {
                  return FilterChip(
                    label: Text(fortification),
                    selected: selectedFortifications.contains(fortification),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedFortifications.add(fortification);
                        } else {
                          selectedFortifications.remove(fortification);
                        }
                      });
                    },
                    selectedColor: Colors.blue[100],
                    checkmarkColor: Colors.blue,
                  );
                }).toList(),
          ),
          if (selectedFortifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'المحدد: ${selectedFortifications.join(', ')}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDatePickerFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null && picked != selectedDate) {
            setState(() {
              selectedDate = picked;
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'التاريخ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFlock() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newFlock = Flock(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        birdType: selectedBirdType,
        name: flockName,
        count: int.parse(count),
        flockType: selectedFlockType,
        supplier: supplier,
        income: 0.0, // Assuming income is 0 for a new flock
        expense: double.parse(oneBirdCost) * int.parse(count),
        fortifications: selectedFortifications,
        oneBirdCost: double.parse(oneBirdCost),
        paidTo: paidTo,
        paymentMethod: selectedPaymentMethod,
        date: selectedDate,
        notes: notes,
      );

      // Save the flock (you'll need to implement this in your controller)
      Get.back(result: newFlock);
    }
  }
}
