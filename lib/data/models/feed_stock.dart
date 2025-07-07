import 'package:hive/hive.dart';
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



@HiveType(typeId: 2)
class FeedStock {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String feedCompany;
  @HiveField(2)
  final FeedType feedType;
  @HiveField(3)
  double quantityInKg;
  @HiveField(4)
  final DateTime purchaseDate;
  @HiveField(5)
  final DateTime? expiryDate;
  @HiveField(6)
  final String? batchNumber;
  @HiveField(7)
  final double totalCost;

  FeedStock({
    required this.feedCompany,
    required this.feedType,
    required this.quantityInKg,
    required this.purchaseDate,
    required this.totalCost,
    this.expiryDate,
    this.batchNumber,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  double get costPerKg => totalCost / quantityInKg;

  String get proteinInfo => '${feedType.proteinPercentage}% بروتين';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feedCompany': feedCompany,
      'feedType': feedType.name,
      'quantity': quantityInKg,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'totalCost': totalCost,
      
    };
  }

  factory FeedStock.fromMap(Map<String, dynamic> map) {
    return FeedStock(
      feedCompany: map['feedCompany'],
      feedType: FeedType.values.firstWhere(
        (e) => e.name == map['feedType'],
        orElse: () => FeedType.badi,
      ),
      quantityInKg: map['quantity'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expiryDate:
          map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      batchNumber: map['batchNumber'],
      totalCost: map['totalCost'],
    );
  }
}

class FeedStockAdapter extends TypeAdapter<FeedStock> {
  @override
  final int typeId = 2;

  @override
  FeedStock read(BinaryReader reader) {
    final map = reader.readMap();
    return FeedStock.fromMap(map.cast<String, dynamic>());
  }

  @override
  void write(BinaryWriter writer, FeedStock obj) {
    writer.writeMap(obj.toMap());
  }
}
