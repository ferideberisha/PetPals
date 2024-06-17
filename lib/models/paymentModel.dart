class Payment {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final bool isDefault;

  Payment({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.isDefault,
  });

  // Convert a Payment object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'isDefault': isDefault,
    };
  }

  // Create a Payment object from a Map object
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      cardNumber: map['cardNumber'],
      expiryDate: map['expiryDate'],
      cvv: map['cvv'],
      isDefault: map['isDefault'],
    );
  }
}
