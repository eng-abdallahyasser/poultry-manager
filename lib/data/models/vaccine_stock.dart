class VaccineStock {
  final String id;
  final String name;
  final String targetDisease;
  final int quantity;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final String? batchNumber;
  final double costPerDose;

  VaccineStock({
    required this.name,
    required this.targetDisease,
    required this.quantity,
    required this.purchaseDate,
    this.expiryDate,
    this.batchNumber,
    required this.costPerDose,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  // Add toMap() and fromMap() similar to FeedStock

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetDisease': targetDisease,
      'quantity': quantity,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'costPerDose': costPerDose,
    };
  }

  factory VaccineStock.fromMap(Map<String, dynamic> map) {
    return VaccineStock(
      name: map['name'],
      targetDisease: map['targetDisease'],
      quantity: map['quantity'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expiryDate: map['expiryDate'] != null 
          ? DateTime.parse(map['expiryDate']) 
          : null,
      batchNumber: map['batchNumber'],
      costPerDose: map['costPerDose'],
    );
  }
}