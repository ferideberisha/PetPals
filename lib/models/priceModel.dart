class Prices {
  final double? dayCarePrice;
  final double? houseSittingPrice;
  final double? walkingPrice;

  Prices({
    this.dayCarePrice,
    this.houseSittingPrice,
    this.walkingPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'dayCarePrice': dayCarePrice,
      'houseSittingPrice': houseSittingPrice,
      'walkingPrice': walkingPrice,
    };
  }

  factory Prices.fromMap(Map<String, dynamic> map) {
    return Prices(
      dayCarePrice: map['dayCarePrice']?.toDouble(),
      houseSittingPrice: map['houseSittingPrice']?.toDouble(),
      walkingPrice: map['walkingPrice']?.toDouble(),
    );
  }
}
