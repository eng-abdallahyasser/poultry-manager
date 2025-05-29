abstract class BirdModification {
  final int count;
  final DateTime date;
  final String notes;
  final double costPerBird;

  BirdModification({
    required this.count,
    required this.date,
    required this.notes,
    this.costPerBird = 0.0,
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
    super.costPerBird = 0.0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'addition',
      'count': count,
      'date': date.toIso8601String(),
      'notes': notes,
      'costPerBird': costPerBird,
    };
  }

  factory BirdAddition.fromMap(Map<String, dynamic> map) {
    return BirdAddition(
      count: map['count'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      costPerBird: map['costPerBird'],
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
    super.costPerBird = 0.0,
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
      'costPerBird': costPerBird,
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
      costPerBird: map['costPerBird'],
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