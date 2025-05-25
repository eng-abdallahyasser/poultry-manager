import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_manager/data/models/bird_modification.dart';
import 'package:poultry_manager/data/models/flok.dart';
import 'package:poultry_manager/modules/dashboard/modify_bird_screen.dart';


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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('نوع الطيور', flock.birdType),
            _buildDetailRow('اسم القطيع', flock.name),
            _buildDetailRow('العدد الحالي', '${flock.currentCount}'),
            _buildDetailRow('السلالة', flock.flockType),
            _buildDetailRow('شركة المورد', flock.supplier),
            _buildDetailRow('التحصينات', flock.fortifications.join(', ')),
            _buildDetailRow('المصروفات', '${flock.expense} جنيه'),
            _buildDetailRow('دفع إلى', flock.paidTo),
            _buildDetailRow('طريقة الدفع', flock.paymentMethod),
            _buildDetailRow('تاريخ الإضافة', _formatDate(flock.date)),
            _buildDetailRow('ملاحظات', flock.notes),
            
            const SizedBox(height: 24),
            const Text(
              'التعديلات:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...flock.modifications.map((mod) => _buildModificationCard(mod)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => ModifyBirdsView(flock: flock)),
        child: const Icon(Icons.edit),
        backgroundColor: Colors.blue,
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

  Widget _buildModificationCard(BirdModification mod) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mod is BirdAddition ? 'إضافة طيور' : 'تخفيض الطيور',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text('الكمية: ${mod.count}'),
            Text('التاريخ: ${_formatDate(mod.date)}'),
            if (mod.notes.isNotEmpty) Text('ملاحظات: ${mod.notes}'),
            if (mod is BirdReduction) ...[
              Text('السبب: ${mod.reason.arabicName}'),
              if (mod.reason == ReductionReason.dead) ...[
                if (mod.color != null) Text('اللون: ${mod.color}'),
                if (mod.weight != null) Text('الوزن: ${mod.weight} كجم'),
                if (mod.secretions != null) Text('الإفرازات: ${mod.secretions}'),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}