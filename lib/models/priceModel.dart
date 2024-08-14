class Prices {
  bool dayCareEnabled;
  bool houseSittingEnabled;
  bool walkingEnabled;
  double? dayCarePrice;
  double? houseSittingPrice;
  double? walkingPrice;

  Prices({
    this.dayCareEnabled = false,
    this.houseSittingEnabled = false,
    this.walkingEnabled = false,
    this.dayCarePrice,
    this.houseSittingPrice,
    this.walkingPrice,
  });

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

  factory Prices.fromMap(Map<String, dynamic> map) {
    return Prices(
      dayCareEnabled: map['dayCareEnabled'] ?? false,
      houseSittingEnabled: map['houseSittingEnabled'] ?? false,
      walkingEnabled: map['walkingEnabled'] ?? false,
      dayCarePrice: map['dayCarePrice']?.toDouble(),
      houseSittingPrice: map['houseSittingPrice']?.toDouble(),
      walkingPrice: map['walkingPrice']?.toDouble(),
    );
  }
}
