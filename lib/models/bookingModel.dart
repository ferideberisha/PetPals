import 'package:intl/intl.dart';

class BookingModel {
  final String userId;
  final String service;
  final String? petName;
  final DateTime date;
  final Set<String> timeSlots;
  final int? numberOfWalks;

  BookingModel({
    required this.userId,
    required this.service,
    this.petName,
    required this.date,
    required this.timeSlots,
    this.numberOfWalks,
  });

  // Method to convert BookingModel instance to a map (for saving to a database)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
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
      userId: map['userId'],
      service: map['service'],
      petName: map['petName'],
      date: DateFormat('yyyy-MM-dd').parse(map['date']), // Parse date from yyyy-MM-dd format
      timeSlots: Set<String>.from(map['timeSlots']),
      numberOfWalks: map['numberOfWalks'],
    );
  }
}
