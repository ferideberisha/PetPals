class Prices {
  final bool dayCareEnabled;
  final bool houseSittingEnabled;
  final bool walkingEnabled;
  final double? dayCarePrice;
  final double? houseSittingPrice;
  final double? walkingPrice;

  Prices({
    required this.dayCareEnabled,
    required this.houseSittingEnabled,
    required this.walkingEnabled,
    this.dayCarePrice,
    this.houseSittingPrice,
    this.walkingPrice,
  });

  // Create Prices from Firestore Document
  factory Prices.fromMap(Map<String, dynamic> data) {
    return Prices(
      dayCareEnabled: data['dayCareEnabled'] ?? false,
      houseSittingEnabled: data['houseSittingEnabled'] ?? false,
      walkingEnabled: data['walkingEnabled'] ?? false,
      dayCarePrice: data['dayCarePrice']?.toDouble(),
      houseSittingPrice: data['houseSittingPrice']?.toDouble(),
      walkingPrice: data['walkingPrice']?.toDouble(),
    );
  }

  // Convert Prices to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'dayCareEnabled': dayCareEnabled,
      'houseSittingEnabled': houseSittingEnabled,
      'walkingEnabled': walkingEnabled,
      'dayCarePrice': dayCarePrice,
      'houseSittingPrice': houseSittingPrice,
      'walkingPrice': walkingPrice,
    };
  }
}