import 'package:cloud_firestore/cloud_firestore.dart';

class Availability {
  final DateTime date;
  final List<TimeSlot> timeSlots;
  final bool isBusyAllDay;

  Availability({
    required this.date,
    required this.timeSlots,
    this.isBusyAllDay = false,
  });

  factory Availability.fromMap(Map<String, dynamic> map) {
    List<dynamic> timeSlotList = map['timeSlots'] ?? [];
    List<TimeSlot> slots = timeSlotList
        .map((slot) => TimeSlot(
              from: (slot['from'] as Timestamp).toDate(),
              to: (slot['to'] as Timestamp).toDate(),
            ))
        .toList();

    return Availability(
      date: (map['date'] as Timestamp).toDate(),
      timeSlots: slots,
      isBusyAllDay: map['isBusyAllDay'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'timeSlots': timeSlots.map((slot) => slot.toMap()).toList(),
      'isBusyAllDay': isBusyAllDay,
    };
  }
}

class TimeSlot {
  final DateTime from;
  final DateTime to;

  TimeSlot({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
    };
  }
}
