import 'package:flutter/material.dart';
import 'package:poultry_manager/data/models/feeding_type.dart';

class FeedTypeChip extends StatelessWidget {
  final FeedType feedType;
  
  const FeedTypeChip({super.key, required this.feedType});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(feedType.arabicName),
      backgroundColor: _getColorForType(feedType),
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  Color _getColorForType(FeedType type) {
    switch (type) {
      case FeedType.badi:
        return Colors.blue;
      case FeedType.nami:
        return Colors.green;
      case FeedType.nahi:
        return Colors.orange;
    }
  }
}