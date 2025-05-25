abstract class BirdModification {
  final int count;
  final DateTime date;
  final String notes;

  BirdModification({
    required this.count,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap();
  
  factory BirdModification.fromMap(Map<String, dynamic> map) {
    if (map['type'] == 'reduction') {
      return BirdReduction.fromMap(map);
    } else {
      return BirdAddition.fromMap(map);
    }
  }
}

class BirdAddition extends BirdModification {
  BirdAddition({
    required super.count,
    required super.date,
    required super.notes,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'addition',
      'count': count,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory BirdAddition.fromMap(Map<String, dynamic> map) {
    return BirdAddition(
      count: map['count'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}

class BirdReduction extends BirdModification {
  final ReductionReason reason;
  final String? color;
  final double? weight;
  final String? secretions;

  BirdReduction({
    required super.count,
    required super.date,
    required super.notes,
    required this.reason,
    this.color,
    this.weight,
    this.secretions,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'reduction',
      'count': count,
      'date': date.toIso8601String(),
      'notes': notes,
      'reason': reason.toString().split('.').last,
      'color': color,
      'weight': weight,
      'secretions': secretions,
    };
  }

  factory BirdReduction.fromMap(Map<String, dynamic> map) {
    return BirdReduction(
      count: map['count'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      reason: ReductionReason.values.firstWhere(
        (e) => e.toString().split('.').last == map['reason'],
      ),
      color: map['color'],
      weight: map['weight'],
      secretions: map['secretions'],
    );
  }
}

enum ReductionReason {
  homeConsumption('استهلاك منزلي'),
  dead('ميت'),
  sold('بيع');

  final String arabicName;
  const ReductionReason(this.arabicName);
}