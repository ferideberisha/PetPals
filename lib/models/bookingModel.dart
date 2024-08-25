import 'package:intl/intl.dart';

class BookingModel {
  final String ownerId; // Changed from userId
  final String walkerId; // Added walkerId
  final String service;
  final String? petName;
  final DateTime date;
  final Set<String> timeSlots;
  final int? numberOfWalks;

  BookingModel({
    required this.ownerId, // Changed from userId
    required this.walkerId, // Added walkerId
    required this.service,
    this.petName,
    required this.date,
    required this.timeSlots,
    this.numberOfWalks,
  });

  // Method to convert BookingModel instance to a map (for saving to a database)
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId, // Changed from userId
      'walkerId': walkerId, // Added walkerId
      'service': service,
      'petName': petName,
      'date': DateFormat('yyyy-MM-dd').format(date), // Store date as string in yyyy-MM-dd format
      'timeSlots': timeSlots.toList(),
      'numberOfWalks': numberOfWalks,
    };
  }

  // Method to create a BookingModel instance from a map (for retrieving from a database)
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      ownerId: map['ownerId'], // Changed from userId
      walkerId: map['walkerId'], // Added walkerId
      service: map['service'],
      petName: map['petName'],
      date: DateFormat('yyyy-MM-dd').parse(map['date']), // Parse date from yyyy-MM-dd format
      timeSlots: Set<String>.from(map['timeSlots']),
      numberOfWalks: map['numberOfWalks'],
    );
  }
}
