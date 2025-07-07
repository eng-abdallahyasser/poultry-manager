import 'package:hive/hive.dart';

@HiveType(typeId: 1)
enum FeedType {
  badi('بادي 23% بروتين', 23),
  nami('نامي 21% بروتين', 21),
  nahi('ناهي 19% بروتين', 19);

  @HiveField(0)
  final String arabicName;
  @HiveField(1)
  final int proteinPercentage;

  const FeedType(this.arabicName, this.proteinPercentage);

  static FeedType fromArabicName(String name) {
    return values.firstWhere(
      (e) => e.arabicName == name,
      orElse: () => values.first,
    );
  }
}

class FeedTypeAdapter extends TypeAdapter<FeedType> {
  @override
  final int typeId = 1;

  @override
  FeedType read(BinaryReader reader) {
    final index = reader.readInt();
    return FeedType.values[index];
  }

  @override
  void write(BinaryWriter writer, FeedType obj) {
    writer.writeInt(obj.index);
  }
}