
class AvailabilityModel {
  List<String> timeSlots;
  bool busyAllDay;

  AvailabilityModel({
    required this.timeSlots,
    this.busyAllDay = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'timeSlots': timeSlots,
      'busyAllDay': busyAllDay,
    };
  }

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      timeSlots: List<String>.from(map['timeSlots'] ?? []),
      busyAllDay: map['busyAllDay'] ?? false,
    );
  }
}
