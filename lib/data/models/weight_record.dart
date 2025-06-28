class WeightRecord {
  final DateTime date;
  final int weightInGrams; // Stored in grams for precision
  final String? notes;

  WeightRecord({
    required this.date,
    required this.weightInGrams,
    this.notes,
  });

  double get weightInKg => weightInGrams / 1000;

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'weightInGrams': weightInGrams,
      'notes': notes,
    };
  }

  factory WeightRecord.fromMap(Map<String, dynamic> map) {
    return WeightRecord(
      date: DateTime.parse(map['date']),
      weightInGrams: map['weightInGrams'],
      notes: map['notes'],
    );
  }
}