class AvailabilityModel {
  List<String> timeSlots;
  List<String> busySlots;
  bool busyAllDay;

  AvailabilityModel({
    required this.timeSlots,
    this.busySlots = const [],
    this.busyAllDay = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'timeSlots': timeSlots,
      'busySlots': busySlots,
      'busyAllDay': busyAllDay,
    };
  }

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      timeSlots: List<String>.from(map['timeSlots'] ?? []),
      busySlots: List<String>.from(map['busySlots'] ?? []),
      busyAllDay: map['busyAllDay'] ?? false,
    );
  }

  List<String> get availableSlots {
    final allSlots = [
      "08:00-09:00", "09:30-10:30", "11:00-12:00", "12:30-13:30",
      "14:00-15:00", "15:30-16:30", "17:00-18:00", "18:30-19:30"
    ];
    if (busyAllDay) return []; // No available slots if busy all day
    return allSlots.where((slot) => !busySlots.contains(slot)).toList();
  }
}
