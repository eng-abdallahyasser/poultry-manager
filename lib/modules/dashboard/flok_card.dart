import 'package:flutter/material.dart';
import 'package:poultry_manager/data/models/flok.dart';

class FlockCard extends StatelessWidget {
  final Flock flock;
  final VoidCallback onTap;

  const FlockCard({
    super.key,
    required this.flock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    flock.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    '${flock.currentCount} طائر',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'النوع: ${flock.birdType}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'السلالة: ${flock.flockType}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'تاريخ الإضافة: ${_formatDate(flock.date)}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}