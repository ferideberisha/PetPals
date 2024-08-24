import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeSlot {
  final String userId;
  final DateTime date;
  final Set<String> selectedSlots;
  final bool busyAllDay;

  TimeSlot({
    required this.userId,
    required this.date,
    required this.selectedSlots,
    required this.busyAllDay,
  });

  // Convert TimeSlot to a map for Firestore, format date without timezone
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': DateFormat('yyyy-MM-dd').format(date), // No timezone
      'selectedSlots': selectedSlots.toList(),
      'busyAllDay': busyAllDay,
    };
  }

  // Convert Firestore document to TimeSlot object
  factory TimeSlot.fromDocument(DocumentSnapshot doc) {
    return TimeSlot(
      userId: doc['userId'],
      date: DateFormat('yyyy-MM-dd').parse(doc['date']), // No timezone
      selectedSlots: Set<String>.from(doc['selectedSlots']),
      busyAllDay: doc['busyAllDay'],
    );
  }
}
