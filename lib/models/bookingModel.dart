import 'package:intl/intl.dart';

class BookingModel {
  final String bookingId; // Add this field
  final String ownerId;
  final String walkerId;
  final String service;
  final String? petName;
  final DateTime date;
  final Set<String> timeSlots;
  final int? numberOfWalks;
  double price;

  BookingModel({
    required this.bookingId,
    required this.ownerId,
    required this.walkerId,
    required this.service,
    this.petName,
    required this.date,
    required this.timeSlots,
    this.numberOfWalks,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId, // Include this field
      'ownerId': ownerId,
      'walkerId': walkerId,
      'service': service,
      'petName': petName,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'timeSlots': timeSlots.toList(),
      'numberOfWalks': numberOfWalks,
      'price': price,
    };
  }

factory BookingModel.fromMap(Map<String, dynamic> map) {
  return BookingModel(
          bookingId: map['bookingId'] ?? '', // Ensure to fetch this field
    ownerId: map['ownerId'] ?? '',
    walkerId: map['walkerId'] ?? '',
    service: map['service'] ?? '',
    petName: map['petName'],
    date: map.containsKey('date') ? DateFormat('yyyy-MM-dd').parse(map['date']) : DateTime.now(),
    timeSlots: Set<String>.from(map['timeSlots'] ?? []),
    numberOfWalks: map['numberOfWalks'],
    price: map['price'] ?? 0.0,
  );
}

}
