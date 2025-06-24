import 'package:poultry_manager/data/models/feeding_type.dart';

enum FeedMeasurementUnit {
  bag50kg('شيكارة 50 كيلو', 50),
  bag25kg('شيكارة 25 كيلو', 25),
  perKg('بالكيلو', 1),
  perTon('بالطن', 1000);

  final String arabicName;
  final double kgEquivalent;

  const FeedMeasurementUnit(this.arabicName, this.kgEquivalent);
}


class FeedStock {
  final String id;
  final String feedCompany;
  final FeedType feedType;
  double quantity;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final String? batchNumber;
  final FeedMeasurementUnit measurementUnit;
  final double totalCost;

  FeedStock({
    required this.feedCompany,
    required this.feedType,
    required this.quantity,
    required this.purchaseDate,
    required this.measurementUnit,
    required this.totalCost,
    this.expiryDate,
    this.batchNumber,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();


  double get costPerKg => totalCost / quantityInKg;
  double get quantityInKg => quantity * measurementUnit.kgEquivalent;

  String get proteinInfo => '${feedType.proteinPercentage}% بروتين';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedCompany': feedCompany,
      'feedType': feedType.name,
      'quantity': quantity,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'totalCost': totalCost,
      'measurementUnit': measurementUnit.name,
    };
  }

  factory FeedStock.fromMap(Map<String, dynamic> map) {
    return FeedStock(
      feedCompany: map['feedCompany'],
      feedType: FeedType.values.firstWhere(
        (e) => e.name == map['feedType'],
        orElse: () => FeedType.badi,
      ),
      quantity: map['quantity'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expiryDate: map['expiryDate'] != null 
          ? DateTime.parse(map['expiryDate']) 
          : null,
      batchNumber: map['batchNumber'],
      measurementUnit: FeedMeasurementUnit.values.firstWhere(
        (e) => e.arabicName == map['measurementUnit'],
        orElse: () => FeedMeasurementUnit.perKg,
      ),
      totalCost: map['totalCost'],
    );
  }
}