import 'dart:developer';

import 'package:poultry_manager/data/models/bird_modification.dart';
import 'package:poultry_manager/data/models/dialy_feeding.dart';
import 'package:poultry_manager/data/models/weight_record.dart';

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
  List<BirdModification> modifications;
  List<DailyFeeding> feedingRecords;
  final List<WeightRecord> weightRecords;

  Flock({
    required this.id,
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
    this.feedingRecords = const [],
    this.weightRecords = const [],
  });

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
      'feedingRecords': feedingRecords.map((x) => x.toMap()).toList(),
      'weightRecords': weightRecords.map((x) => x.toMap()).toList(),
    };
  }

  double get totalFeedCost {
    return feedingRecords.fold(0, (sum, record) => sum + record.totalCost);
  }

  double get totalIncome {
    return income +
        modifications.fold(0, (sum, mod) {
          if (mod is BirdReduction && mod.reason == ReductionReason.sold) {
            return sum + mod.cost;
          }
          return sum;
        });
  }

  double get totalExpense {
    double modificationsExpense = 0;
    for (var mod in modifications) {
      if (mod is BirdAddition) {
        modificationsExpense += mod.cost;
      }
    }
    return expense + modificationsExpense + totalFeedCost;
  }

  double get feedingConsumptionAverage {
    if (feedingRecords.isEmpty) return 0;
    double feedingConsumptionAverage = feedingRecords.fold(
      0,
      (sum, record) => sum + (record.quantity / record.countOfBirdsThen),
    );
    return feedingConsumptionAverage*1000;//(*1000) to be in grams
  }

  int get ageInDays {
    return DateTime.now().difference(date).inDays+1;
  }

  int get averageWeight {
    if (weightRecords.isEmpty) return 0;
    return weightRecords.last.weightInGrams;
  }

  double get conversionRatePercent {
    if (feedingConsumptionAverage == 0) return 0;
    log("Average Weight: $averageWeight");
    return (averageWeight / feedingConsumptionAverage)*100;
  }

  int get deadCount {
    return modifications
        .where((m) => m is BirdReduction && m.reason == ReductionReason.dead)
        .fold(0, (sum, m) => sum + (m as BirdReduction).count);
  }

  int get soldCount {
    return modifications
        .where((m) => m is BirdReduction && m.reason == ReductionReason.sold)
        .fold(0, (sum, m) => sum + (m as BirdReduction).count);
  }

  int get currentCount {
    int currentCount = count;
    for (var mod in modifications) {
      if (mod is BirdReduction) {
        
          currentCount -= mod.count;
      } else if (mod is BirdAddition) {
        currentCount += mod.count;
      }
    }
    return currentCount;
  }

  factory Flock.fromMap(Map<String, dynamic> map) {
    return Flock(
      id: map['id'],
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
      modifications:
          List<dynamic>.from(
            map['modifications'] ?? [],
          ).map((m) => BirdModification.fromMap(m)).toList(),
      feedingRecords: List<DailyFeeding>.from(
        map['feedingRecords']?.map((x) => DailyFeeding.fromMap(x)) ?? [],
      ),
      weightRecords: List<WeightRecord>.from(
        map['weightRecords']?.map((x) => WeightRecord.fromMap(x)) ?? [],
      ),
    );
  }

  Flock copyWith({
    String? id,
    String? birdType,
    String? name,
    int? count,
    String? flockType,
    String? supplier,
    List<String>? fortifications,
    double? oneBirdCost,
    double? income,
    double? expense,
    String? paidTo,
    String? paymentMethod,
    DateTime? date,
    String? notes,
    List<BirdModification>? modifications,
    List<DailyFeeding>? feedingRecords,
    List<WeightRecord>? weightRecords,
  }) {
    return Flock(
      id: id ?? this.id,
      birdType: birdType ?? this.birdType,
      name: name ?? this.name,
      count: count ?? this.count,
      flockType: flockType ?? this.flockType,
      supplier: supplier ?? this.supplier,
      fortifications: fortifications ?? this.fortifications,
      oneBirdCost: oneBirdCost ?? this.oneBirdCost,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      paidTo: paidTo ?? this.paidTo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      modifications: modifications ?? this.modifications,
      feedingRecords: feedingRecords ?? this.feedingRecords,
      weightRecords: weightRecords ?? this.weightRecords,
    );
  }
}
