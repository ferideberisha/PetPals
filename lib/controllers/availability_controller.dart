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

Future<void> updateAvailability(String userId, DateTime date, Set<String> bookedSlots) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    // Document reference
    final docRef = firestore.collection('users')
      .doc(userId)
      .collection('walkerInfo')
      .doc(userId)
      .collection('availability')
      .doc(formattedDate);

    // Fetch existing document
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      List<String> currentSlots = List<String>.from(data['timeSlots'] ?? []);
      currentSlots.addAll(bookedSlots);
      await docRef.update({'timeSlots': currentSlots});
    } else {
      // Create a new document with the booked slots
      await docRef.set({'timeSlots': bookedSlots.toList()});
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
