import 'package:poultry_manager/data/models/bird_modification.dart';

class Flock {
  final String id;
  final String birdType;
  final String name;
  final int count;
  final String flockType;
  final String supplier;
  final List<String> fortifications;
  final double oneBirdCost;
  final double income;
  final double expense;
  final String paidTo;
  final String paymentMethod;
  final DateTime date;
  final String notes;
  final List<BirdModification> modifications;


  Flock({
    required this.birdType,
    required this.name,
    required this.count,
    required this.flockType,
    required this.supplier,
    required this.fortifications,
    required this.oneBirdCost,
    required this.income,
    required this.expense,
    required this.paidTo,
    required this.paymentMethod,
    required this.date,
    required this.notes,
    this.modifications = const [],
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'birdType': birdType,
      'name': name,
      'count': count,
      'flockType': flockType,
      'supplier': supplier,
      'fortifications': fortifications,
      'oneBirdCost': oneBirdCost,
      'income': income,
      'expense': expense,
      'paidTo': paidTo,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(),
      'notes': notes,
      'modifications': modifications.map((mod) => mod.toMap()).toList(),
    };
  }
    int get currentCount {
    int modifiedCount = count;
    for (var mod in modifications) {
      if (mod is BirdReduction) {
        modifiedCount -= mod.count;
      } else if (mod is BirdAddition) {
        modifiedCount += mod.count;
      }
    }
    return modifiedCount;
  }

  factory Flock.fromMap(Map<String, dynamic> map) {
    return Flock(
      birdType: map['birdType'],
      name: map['name'],
      count: map['count'],
      flockType: map['flockType'],
      supplier: map['supplier'],
      fortifications: List<String>.from(map['fortifications']),
      oneBirdCost: map['oneBirdCost'],
      income: map['income'],
      expense: map['expense'],
      paidTo: map['paidTo'],
      paymentMethod: map['paymentMethod'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
       modifications: List<dynamic>.from(map['modifications'])
          .map((m) => BirdModification.fromMap(m))
          .toList(),
    );
  }
}
