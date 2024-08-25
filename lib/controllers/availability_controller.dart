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

    Future<void> updateAvailability(String userId, DateTime date, Set<String> busySlots) async {
    try {
      // Fetch existing availability
      AvailabilityModel? availability = await getAvailability(userId, date);

      if (availability != null) {
        // Remove the busy slots from the available slots
        List<String> updatedTimeSlots = availability.timeSlots.where((slot) => !busySlots.contains(slot)).toList();
        AvailabilityModel updatedAvailability = AvailabilityModel(
          timeSlots: updatedTimeSlots,
          busyAllDay: updatedTimeSlots.isEmpty,
        );

        // Save the updated availability to the database
        await saveAvailability(userId, date, updatedAvailability);
      } else {
        // Handle case where availability is not found (perhaps initialize it)
        print('No availability found for the selected date.');
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }
}
