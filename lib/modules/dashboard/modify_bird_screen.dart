import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/bird_modification.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';

class ModifyBirdsView extends StatefulWidget {
  final Flock flock;

  const ModifyBirdsView({super.key, required this.flock});

  @override
  State<ModifyBirdsView> createState() => _ModifyBirdsViewState();
}

class _ModifyBirdsViewState extends State<ModifyBirdsView> {
  final _formKey = GlobalKey<FormState>();
  final List<String> reductionReasons =
      ReductionReason.values.map((e) => e.arabicName).toList();

  DashboardController controller = Get.find<DashboardController>();

  String modificationType = 'add';
  String count = '';
  ReductionReason? selectedReason;
  String notes = '';
  bool isCostPerBird = false;
  double? cost;
  String? color;
  double? weight;
  String? secretions;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل عدد الطيور'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Modification Type
              _buildModificationTypeSelector(),

              // Count
              _buildTextFormField(
                label: 'العدد',
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'الرجاء إدخال العدد' : null,
                onSaved: (value) => count = value!,
              ),

              _buildTextFormField(
                label: "التكلفة (اختياري)",
                keyboardType: TextInputType.number,
                onSaved: (newValue) => cost = double.tryParse(newValue ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "نوع التكلفة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: "لكل طائر",
                      child: Text("تكلفة كل طائر"),
                    ),
                    DropdownMenuItem<String>(
                      value: "التكلفة الكلية",
                      child: Text("التكلفة الكلية"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value == "لكل طائر") {
                        isCostPerBird = true;
                      } else {
                        isCostPerBird = false;
                      }
                    });
                  },
                ),
              ),

              // For reductions only
              if (modificationType == 'reduce') ...[
                _buildDropdownFormField(
                  label: 'سبب التخفيض',
                  items: reductionReasons,
                  onChanged: (value) {
                    setState(() {
                      selectedReason =
                          ReductionReason.values[reductionReasons.indexOf(
                            value!,
                          )];
                    });
                  },
                  validator:
                      (value) => value == null ? 'الرجاء اختيار السبب' : null,
                ),
              ],

              // Additional fields for dead birds
              if (selectedReason?.arabicName == 'ميت') ...[
                _buildTextFormField(
                  label: 'اللون (اختياري)',
                  onSaved: (value) => color = value,
                ),
                _buildTextFormField(
                  label: 'الوزن بالكجم (اختياري)',
                  keyboardType: TextInputType.number,
                  onSaved: (value) => weight = double.tryParse(value ?? ''),
                ),
                _buildTextFormField(
                  label: 'الإفرازات (اختياري)',
                  onSaved: (value) => secretions = value,
                ),
              ],

              // Date
              _buildDatePickerFormField(),

              // Notes
              _buildTextFormField(
                label: 'ملاحظات',
                maxLines: 3,
                onSaved: (value) => notes = value ?? '',
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _submitModification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('حفظ التعديل'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModificationTypeSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: ChoiceChip(
              label: const Text('إضافة'),
              selected: modificationType == 'add',
              onSelected: (selected) {
                setState(() {
                  modificationType = 'add';
                  selectedReason = null;
                });
              },
              selectedColor: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ChoiceChip(
              label: const Text('تخفيض'),
              selected: modificationType == 'reduce',
              onSelected: (selected) {
                setState(() {
                  modificationType = 'reduce';
                });
              },
              selectedColor: Colors.blue,
            ),
          ),
        ],
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
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
        validator: validator,
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

  void _submitModification() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      BirdModification modification;
      if (modificationType == 'add') {
        modification = BirdAddition(
          count: int.parse(count),
          date: selectedDate,
          notes: notes,
          cost:
              (isCostPerBird && cost != null)
                  ? cost! * int.parse(count)
                  : cost!,
        );
      } else {
        modification = BirdReduction(
          count: int.parse(count),
          date: selectedDate,
          notes: notes,
          cost:
              (isCostPerBird && cost != null)
                  ? cost! * int.parse(count)
                  : cost!,
          reason: selectedReason!,
          color: color,
          weight: weight,
          secretions: secretions,
        );
      }

      // Update the flock with the new modification
      final updatedFlock = Flock(
        id: widget.flock.id,
        birdType: widget.flock.birdType,
        name: widget.flock.name,
        count: widget.flock.count,
        flockType: widget.flock.flockType,
        supplier: widget.flock.supplier,
        fortifications: widget.flock.fortifications,
        expense: widget.flock.expense,
        income: widget.flock.income,
        oneBirdCost: widget.flock.oneBirdCost,
        paidTo: widget.flock.paidTo,
        paymentMethod: widget.flock.paymentMethod,
        date: widget.flock.date,
        notes: widget.flock.notes,
        modifications: [...widget.flock.modifications, modification],
      );

      controller.saveAndNavigateToFlockDetails(updatedFlock);
    }
  }
}
