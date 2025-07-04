import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/doctor_check.dart';
import 'package:poultry_manager/modules/dashboard/dashboard_controller.dart';
import 'package:poultry_manager/modules/global_widgets/custom_btn.dart';

class DoctorCheckScreen extends StatefulWidget {
  final String flockId;

  const DoctorCheckScreen({super.key, required this.flockId});

  @override
  State<DoctorCheckScreen> createState() => _DoctorCheckScreenState();
}

class _DoctorCheckScreenState extends State<DoctorCheckScreen> {
  DashboardController controller = Get.find<DashboardController>();
  final _formKey = GlobalKey<FormState>();
  final _doctorNameController = TextEditingController();
  final _notesController = TextEditingController();

  // External Check
  int _generalCondition = 5;
  int _activityLevel = 5;
  int _appetite = 5;
  var _featherCondition = FeatherCondition.normal;
  int _featherScore = 5;

  // Subcutaneous Check
  bool _hasBleeding = false;
  int _bleedingSeverity = 1;
  final _bleedingLocationController = TextEditingController();

  // Liver Check
  var _liverSize = LiverSize.normal;
  var _liverColor = LiverColor.normal;
  var _liverTexture = LiverTexture.firm;
  int _liverAbnormalityScore = 1;

  // Lung Check
  var _hasAbnormalSound = false;
  var _breathingDifficulty = 1;
  var _congestionScore = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فحص الدكتور'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info
              _buildDoctorInfoSection(),
              const SizedBox(height: 16),

              // External Check
              _buildSectionHeader('الفحص الخارجي'),
              _buildExternalCheckSection(),
              const SizedBox(height: 16),

              // Subcutaneous Check
              _buildSectionHeader('فحص تشريحي'),
              _buildSubcutaneousCheckSection(),
              const SizedBox(height: 16),

              // Liver Check
              _buildLiverCheckSection(),
              const SizedBox(height: 16),

              // Lung Check
              _buildLungCheckSection(),
              const SizedBox(height: 16),

              // Notes
              _buildNotesSection(),
              const SizedBox(height: 24),

              // Submit Button
              CustomBtn(title: 'حفظ الفحص', onTap: _submitForm),
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

  Widget _buildDoctorInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _doctorNameController,
              decoration: const InputDecoration(
                labelText: 'اسم الدكتور',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم الدكتور';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildDatePicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 1),
          lastDate: now,
        );
        if (picked != null) {
          setState(() {});
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'تاريخ الفحص',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${now.day}/${now.month}/${now.year}'),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildExternalCheckSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSliderItem('الحالة العامة', _generalCondition.toDouble(), (
              value,
            ) {
              setState(() => _generalCondition = value.round());
            }),
            _buildSliderItem('مستوى النشاط', _activityLevel.toDouble(), (
              value,
            ) {
              setState(() => _activityLevel = value.round());
            }),
            _buildSliderItem('الشهية', _appetite.toDouble(), (value) {
              setState(() => _appetite = value.round());
            }),
            const SizedBox(height: 12),
            _buildSliderItem('تقييم الريش', _featherScore.toDouble(), (value) {
              setState(() => _featherScore = value.round());
            }),
            _buildDropdownItem<FeatherCondition>(
              'حالة الريش',
              _featherCondition,
              FeatherCondition.values,
              (value) => setState(() => _featherCondition = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcutaneousCheckSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('وجود نزيف'),
              value: _hasBleeding,
              onChanged: (value) => setState(() => _hasBleeding = value),
            ),
            if (_hasBleeding) ...[
              _buildSliderItem('شدة النزيف', _bleedingSeverity.toDouble(), (
                value,
              ) {
                setState(() => _bleedingSeverity = value.round());
              }),
              TextFormField(
                controller: _bleedingLocationController,
                decoration: const InputDecoration(
                  labelText: 'موقع النزيف',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLiverCheckSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdownItem<LiverSize>(
              'حجم الكبد',
              _liverSize,
              LiverSize.values,
              (value) => setState(() => _liverSize = value!),
            ),
            _buildDropdownItem<LiverColor>(
              'لون الكبد',
              _liverColor,
              LiverColor.values,
              (value) => setState(() => _liverColor = value!),
            ),
            _buildDropdownItem<LiverTexture>(
              'ملمس الكبد',
              _liverTexture,
              LiverTexture.values,
              (value) => setState(() => _liverTexture = value!),
            ),
            _buildSliderItem('درجة الشذوذ', _liverAbnormalityScore.toDouble(), (
              value,
            ) {
              setState(() => _liverAbnormalityScore = value.round());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLungCheckSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('أصوات غير طبيعية'),
              value: _hasAbnormalSound,
              onChanged: (value) => setState(() => _hasAbnormalSound = value),
            ),
            _buildSliderItem('صعوبة التنفس', _breathingDifficulty.toDouble(), (
              value,
            ) {
              setState(() => _breathingDifficulty = value.round());
            }),
            _buildSliderItem('درجة الاحتقان', _congestionScore.toDouble(), (
              value,
            ) {
              setState(() => _congestionScore = value.round());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'ملاحظات الدكتور',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _buildSliderItem(
    String label,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value.round().toString()),
            ],
          ),
        ),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownItem<T>(
    String label,
    T value,
    List<T> items,
    Function(T?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: value,
        items:
            items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(_getArabicName(item)),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  String _getArabicName(dynamic enumValue) {
    if (enumValue is FeatherCondition) {
      return enumValue.arabicName;
    } else if (enumValue is LiverSize) {
      return enumValue.arabicName;
    } else if (enumValue is LiverColor) {
      return enumValue.arabicName;
    } else if (enumValue is LiverTexture) {
      return enumValue.arabicName;
    }
    return enumValue.toString();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final check = DoctorCheck(
        date: DateTime.now(),
        doctorName: _doctorNameController.text,
        external: ExternalCheck(
          generalCondition: _generalCondition,
          activityLevel: _activityLevel,
          appetite: _appetite,
          featherCondition: _featherCondition,
          featherScore: _featherScore,
        ),
        subcutaneous: SubcutaneousCheck(
          hasBleeding: _hasBleeding,
          bleedingSeverity: _bleedingSeverity,
          bleedingLocation:
              _hasBleeding ? _bleedingLocationController.text : null,
        ),
        liver: LiverCheck(
          size: _liverSize,
          color: _liverColor,
          texture: _liverTexture,
          abnormalityScore: _liverAbnormalityScore,
        ),
        lungs: LungCheck(
          hasAbnormalSound: _hasAbnormalSound,
          breathingDifficulty: _breathingDifficulty,
          congestionScore: _congestionScore,
        ),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      controller.addDoctorCheck(widget.flockId, check);

      Get.back();
      Get.snackbar(
        'تم الحفظ',
        'تم حفظ فحص الدكتور بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _bleedingLocationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
