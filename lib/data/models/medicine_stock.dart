class MedicineStock {
  final String id;
  final String name;
  final String supplier;
  final double quantity;
  final String unit; // جرام, مل, etc.
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final String? batchNumber;
  final double costPerUnit;

  MedicineStock({
    required this.name,
    required this.supplier,
    required this.quantity,
    required this.unit,
    required this.purchaseDate,
    this.expiryDate,
    this.batchNumber,
    required this.costPerUnit,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  // Add toMap() and fromMap() similar to FeedStock
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'supplier': supplier,
      'quantity': quantity,
      'unit': unit,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'costPerUnit': costPerUnit,
    };
  }

  factory MedicineStock.fromMap(Map<String, dynamic> map) {
    return MedicineStock(
      name: map['name'],
      supplier: map['supplier'],
      quantity: map['quantity'],
      unit: map['unit'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expiryDate: map['expiryDate'] != null 
          ? DateTime.parse(map['expiryDate']) 
          : null,
      batchNumber: map['batchNumber'],
      costPerUnit: map['costPerUnit'],
    );
  }
} 