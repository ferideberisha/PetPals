import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/availabilityModel.dart';

class AvailabilityController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveAvailability(String userId, DateTime date, AvailabilityModel availability) async {
  try {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    await _firestore.collection('users')
        .doc(userId)
        .collection('walkerInfo')
        .doc(userId)
        .collection('availability')
        .doc(formattedDate)
        .set(availability.toMap());
  } catch (e) {
    print('Error saving availability: $e');
  }
}


  Future<AvailabilityModel?> getAvailability(String userId, DateTime date) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot doc = await _firestore.collection('users')
          .doc(userId)
          .collection('walkerInfo')
          .doc(userId)
          .collection('availability')
          .doc(formattedDate)
          .get();

      if (doc.exists) {
        return AvailabilityModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching availability: $e');
      return null;
    }
  }

Future<void> updateAvailability(String userId, DateTime date, Set<String> bookedSlots, Set<String> walkerSlots) async {
  try {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final docRef = _firestore.collection('users')
      .doc(userId)
      .collection('walkerInfo')
      .doc(userId)
      .collection('availability')
      .doc(formattedDate);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      
      // Get current busySlots and timeSlots
      Set<String> currentBusySlots = Set.from(data['busySlots'] ?? []);
      List<String> currentTimeSlots = List<String>.from(data['timeSlots'] ?? []);

      // Remove booked slots from timeSlots
      currentTimeSlots.removeWhere((slot) => bookedSlots.contains(slot));
      
      // Update busySlots and timeSlots
      await docRef.update({
        'busySlots': currentBusySlots.union(bookedSlots).toList(),
        'timeSlots': currentTimeSlots,
      });
    } else {
      // If document doesn't exist, create it with booked slots in busySlots and walker slots in timeSlots
      await docRef.set({
        'busySlots': bookedSlots.toList(),
        'timeSlots': walkerSlots.difference(bookedSlots).toList(),
      });
    }
  } catch (e) {
    print('Error updating availability: $e');
    throw e; // Re-throw the error to be handled by the caller
  }
}

  List<String> _getAllTimeSlots() {
    // Define the time slots consistent with the ones used in TimeSlotsPage
    return [
      "08:00-09:00",
      "09:30-10:30",
      "11:00-12:00",
      "12:30-13:30",
      "14:00-15:00",
      "15:30-16:30",
      "17:00-18:00",
      "18:30-19:30"
    ];
  }
}
