import 'package:intl/intl.dart';

class BookingModel {
  final String userId;
  final DateTime date;
  final String timeSlot;
  final String status;

  BookingModel({
    required this.userId,
    required this.date,
    required this.timeSlot,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': DateFormat('yyyy-MM-dd').format(date), // No timezone
      'timeSlot': timeSlot,
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      userId: map['userId'],
      date: DateFormat('yyyy-MM-dd').parse(map['date']),
      timeSlot: map['timeSlot'],
      status: map['status'],
    );
  }
}
