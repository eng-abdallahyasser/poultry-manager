import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_manager/data/models/flok.dart';

class FlockStatsCard extends StatelessWidget {
  final Flock flock;
  final DateFormat dateFormat = DateFormat('yyyy/MM/dd');

  FlockStatsCard({super.key, required this.flock});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Row
            _buildHeaderRow(),
            const Divider(height: 24),
            
            // Stats Grid
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        // Bird Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.agriculture, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        
        // Titles
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flock.birdType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              flock.flockType,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 2.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _buildStatItem('العمر', '${flock.ageInDays} يوم', Icons.calendar_today),
        _buildStatItem('تاريخ البدء', dateFormat.format(flock.date), Icons.date_range),
        _buildStatItem('متوسط الوزن', '${(flock.averageWeight/1000).toStringAsFixed(2)} كجم', Icons.monitor_weight),
        _buildStatItem('معدل التحويل', '${flock.conversionRatePercent.toStringAsFixed(2)} %', Icons.trending_up),
        _buildStatItem('العدد الكلي', '${flock.count} طائر', Icons.format_list_numbered),
        _buildStatItem('العدد الحالي', '${flock.currentCount} طائر', Icons.egg),
        _buildStatItem('عدد البيع', '${flock.soldCount} طائر', Icons.sell),
        _buildStatItem('عدد النافق', '${flock.deadCount} طائر', Icons.heart_broken),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}