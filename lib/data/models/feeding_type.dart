enum FeedType {
  badi('بادي 23% بروتين', 23),
  nami('نامي 21% بروتين', 21),
  nahi('ناهي 19% بروتين', 19);

  final String arabicName;
  final int proteinPercentage;

  const FeedType(this.arabicName, this.proteinPercentage);

  static FeedType fromArabicName(String name) {
    return values.firstWhere(
      (e) => e.arabicName == name,
      orElse: () => values.first,
    );
  }
}