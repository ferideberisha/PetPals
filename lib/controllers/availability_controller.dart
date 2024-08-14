import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/availabilityModel.dart';

class AvailabilityController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Set or update availability document
  Future<void> setAvailability(String userId, Availability availability) async {
    try {
      // Define the path
      final path = 'users/$userId/walkerInfo/$userId/availability';

      // Create a new document with an auto-generated ID
      DocumentReference availabilityRef = _firestore.collection(path).doc();

      // Set availability data in the new document
      await availabilityRef.set(availability.toMap());
    } catch (e) {
      print('Error setting availability: $e');
      // Handle error appropriately
    }
  }

  // Fetch availability documents
  Future<List<Availability>> getAvailability(String userId) async {
    try {
      // Define the path
      final path = 'users/$userId/walkerInfo/$userId/availability';

      // Fetch all availability documents
      final querySnapshot = await _firestore.collection(path).get();

      // Convert all fetched documents to a list of Availability
      return querySnapshot.docs.map((doc) {
        return Availability.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching availability: $e');
      return [];
    }
  }

  // Add a time slot to an existing availability document
  Future<void> addTimeSlot(String userId, String availabilityId, TimeSlot newTimeSlot) async {
    try {
      // Define the path
      final path = 'users/$userId/walkerInfo/$userId/availability/$availabilityId';

      // Fetch the existing document
      DocumentSnapshot snapshot = await _firestore.doc(path).get();

      if (snapshot.exists) {
        // Convert the existing data to an Availability object
        Availability availability = Availability.fromMap(snapshot.data() as Map<String, dynamic>);

        // Add the new time slot
        availability.timeSlots.add(newTimeSlot);

        // Update the document with the new time slot added
        await _firestore.doc(path).set(availability.toMap());
      } else {
        print('Availability document not found');
      }
    } catch (e) {
      print('Error adding time slot: $e');
    }
  }

  // Update an entire availability document
  Future<void> updateAvailability(String userId, String availabilityId, Availability updatedAvailability) async {
    try {
      // Define the path
      final path = 'users/$userId/walkerInfo/$userId/availability/$availabilityId';

      // Update the document with the new availability data
      await _firestore.doc(path).set(updatedAvailability.toMap());
    } catch (e) {
      print('Error updating availability: $e');
    }
  }
}
