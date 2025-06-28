import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_manager/data/models/bird_modification.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';
import 'package:poultry_manager/modules/global_widgets/custom_btn.dart';

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
              Row(
                children: [],
              ),

              _buildTextFormField(
                label: "التكلفة (اختياري)",
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? 'الرجاء إدخال التكلفة' : null,
                onSaved:
                    (newValue) => cost = double.tryParse(newValue ?? ''),
              )
              ,Padding(
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
              CustomBtn(title: 'حفظ التعديل', onTap: _submitModification),
              SizedBox(height: 16),
              if (widget.flock.modifications.isEmpty) _buildEmptyModifications(),
                  if (widget.flock.modifications.isNotEmpty)
                    ...widget.flock.modifications.map(
                      (mod) => _buildModificationCard(mod),
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
      final updatedFlock = widget.flock.copyWith(
        modifications: [...widget.flock.modifications,modification]
      );

      controller.saveAndNavigateToFlockDetails(updatedFlock);
     
    }
  }
  Widget _buildEmptyModifications() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'لا توجد تعديلات مسجلة',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildModificationCard(BirdModification mod) {
    final isAddition = mod is BirdAddition;
    final icon =
        isAddition
            ? const Icon(Icons.add_circle, color: Colors.green)
            : const Icon(Icons.remove_circle, color: Colors.red);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  isAddition ? 'إضافة طيور' : 'تخفيض الطيور',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${mod.count} طائر ${'- ${mod.cost} جنيه'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAddition ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildModificationDetailRow('التاريخ', _formatDateTime(mod.date)),
            if (mod is BirdReduction) ...[
              _buildModificationDetailRow('السبب', mod.reason.arabicName),
              if (mod.reason == ReductionReason.dead) ...[
                if (mod.color != null)
                  _buildModificationDetailRow('اللون', mod.color!),
                if (mod.weight != null)
                  _buildModificationDetailRow('الوزن', '${mod.weight} كجم'),
                if (mod.secretions != null)
                  _buildModificationDetailRow('الإفرازات', mod.secretions!),
              ],
            ],
            if (mod.notes.isNotEmpty)
              _buildModificationDetailRow('ملاحظات', mod.notes),
          ],
        ),
      ),
    );
  }

  Widget _buildModificationDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('yyyy/MM/dd - hh:mm a').format(date);
  }
}
