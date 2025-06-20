import 'package:poultry_manager/data/models/feeding_type.dart';

class DailyFeeding {
  final String id;
  final DateTime date;
  final double quantity; // in kg
  final String feedCompany;
  final FeedType feedType;
  final String? notes;
  final double costPerKg;

  DailyFeeding({
    required this.date,
    required this.quantity,
    required this.feedCompany,
    required this.feedType,
    this.notes,
    required this.costPerKg,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  double get totalCost => quantity * costPerKg;
  String get proteinInfo => '${feedType.proteinPercentage}% بروتين';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'quantity': quantity,
      'feedCompany': feedCompany,
      'feedType': feedType.name, // Store enum name
      'notes': notes,
      'costPerKg': costPerKg,
    };
  }

  factory DailyFeeding.fromMap(Map<String, dynamic> map) {
    return DailyFeeding(
      date: DateTime.parse(map['date']),
      quantity: map['quantity'],
      feedCompany: map['feedCompany'],
      feedType: FeedType.values.firstWhere(
        (e) => e.name == map['feedType'],
        orElse: () => FeedType.badi,
      ),
      notes: map['notes'],
      costPerKg: map['costPerKg'],
    );
  }
}