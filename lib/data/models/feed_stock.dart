import 'package:poultry_manager/data/models/feeding_type.dart';

class FeedStock {
  final String id;
  final String feedCompany;
  final FeedType feedType;
  final double quantity;
  final double costPerKg;
  final DateTime purchaseDate;
  final DateTime? expiryDate;
  final String? batchNumber;

  FeedStock({
    required this.feedCompany,
    required this.feedType,
    required this.quantity,
    required this.costPerKg,
    required this.purchaseDate,
    this.expiryDate,
    this.batchNumber,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  String get proteinInfo => '${feedType.proteinPercentage}% بروتين';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedCompany': feedCompany,
      'feedType': feedType.name,
      'quantity': quantity,
      'costPerKg': costPerKg,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
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
      costPerKg: map['costPerKg'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expiryDate: map['expiryDate'] != null 
          ? DateTime.parse(map['expiryDate']) 
          : null,
      batchNumber: map['batchNumber'],
    );
  }
}