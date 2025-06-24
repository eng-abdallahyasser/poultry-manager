import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/bird_modification.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/daily_feeding_form.dart';
import 'package:poultry_manager/modules/dashboard/modify_bird_screen.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class FlockDetailsView extends StatelessWidget {
  final Flock flock;

  const FlockDetailsView({super.key, required this.flock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل القطيع - ${flock.name}'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          "الربح",
                          flock.income - flock.expense,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _buildSummaryCard("المصروفات", flock.expense),
                            const SizedBox(width: 16),
                            _buildSummaryCard("الإيرادات", flock.income),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Flock Basic Information Section
                  _buildSectionHeader('المعلومات الأساسية'),
                  _buildDetailCard([
                    _buildDetailRow('نوع الطيور', flock.birdType),
                    _buildDetailRow('اسم القطيع', flock.name),
                    _buildDetailRow('العدد الأصلي', '${flock.count}'),
                    _buildDetailRow('العدد الحالي', '${flock.currentCount}'),
                    _buildDetailRow('السلالة', flock.flockType),
                    _buildDetailRow('شركة المورد', flock.supplier),
                  ]),

                  // Financial Information Section
                  _buildSectionHeader('المعلومات المالية'),
                  _buildDetailCard([
                    _buildDetailRow('سعر الكتكوت', '${flock.oneBirdCost} جنيه'),
                    _buildDetailRow('دفع إلى', flock.paidTo),
                    _buildDetailRow('طريقة الدفع', flock.paymentMethod),
                  ]),

                  // Additional Information Section
                  _buildSectionHeader('معلومات إضافية'),
                  _buildDetailCard([
                    _buildDetailRow(
                      'التحصينات',
                      flock.fortifications.join(', '),
                    ),
                    _buildDetailRow('تاريخ الإضافة', _formatDate(flock.date)),
                    if (flock.notes.isNotEmpty)
                      _buildDetailRow('ملاحظات', flock.notes),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildModifyBirdBtn(),
                      const SizedBox(width: 16),
                      _buildDailyFeedingBtn(),
                      const SizedBox(width: 16),
                      _buildBirdHealthBth()
                    ],
                  ),
                  // Modifications Section
                  _buildSectionHeader(
                    'سجل التعديلات (${flock.modifications.length})',
                  ),

                  if (flock.modifications.isEmpty) _buildEmptyModifications(),
                  if (flock.modifications.isNotEmpty)
                    ...flock.modifications.map(
                      (mod) => _buildModificationCard(mod),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirdHealthBth() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to bird health screen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.health_and_safety, color: Colors.white),
          SizedBox(width: 16),
          Text('صحة الطيور', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDailyFeedingBtn() {
    return ElevatedButton(
      onPressed: ()  {
         Get.to<Flock>(
          () => DailyFeedingForm( onSave: (dailyFeeding){
            flock.feedingRecords.add(dailyFeeding);
            Get.back(result: flock);
          },),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.fastfood, color: Colors.white),
          SizedBox(width: 16),
          Text('تغذية يومية', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildModifyBirdBtn() {
    return ElevatedButton(
      onPressed: () async {
        final updatedFlock = await Get.to<Flock>(
          () => ModifyBirdsView(flock: flock),
        );
        if (updatedFlock != null) {
          Get.back(result: updatedFlock);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 16),
          Text('تعديل الطيور', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: Get.textTheme.titleSmall),
              Text(
                '\$${value.toStringAsFixed(2)}',
                style: Get.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
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

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
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
                  '${mod.count} طائر',
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

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('yyyy/MM/dd - hh:mm a').format(date);
  }
}
