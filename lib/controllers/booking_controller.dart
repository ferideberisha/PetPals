import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/bookingModel.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking({
    required String ownerId,
    required String walkerId,
    required BookingModel booking, required String role,
  }) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);

      // Save booking in both places in parallel
      await Future.wait([
        _saveBookingForWalker(walkerId, booking, formattedDate),
        _saveBookingForOwner(ownerId, booking, formattedDate),
      ]);

      // Optionally, update walker's availability
      await _updateWalkerAvailability(walkerId, booking);
    } catch (e) {
      print('Error creating booking: $e');
    }
  }

  Future<void> _saveBookingForWalker(String walkerId, BookingModel booking, String formattedDate) async {
    try {
      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId) // Use walkerId for document path
          .collection('booking')
          .doc('incomingRequest')
          .collection(formattedDate)
          .doc() // Auto-generated document ID
          .set({
            'date': formattedDate,
            'numberOfWalks': booking.numberOfWalks,
            'ownerId': booking.ownerId, // Current user ID as ownerId
            'petName': booking.petName,
            'service': booking.service,
            'timeSlots': booking.timeSlots.toList(),
            'walkerId': booking.walkerId, // Walker ID
          });
    } catch (e) {
      print('Error saving booking for walker: $e');
    }
  }

  Future<void> _saveBookingForOwner(String ownerId, BookingModel booking, String formattedDate) async {
    try {
      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(booking.ownerId) // Use walkerId for the path
          .collection('booking')
          .doc('outgoingRequest')
          .collection(formattedDate)
          .doc() // Auto-generated document ID
          .set({
            'date': formattedDate,
            'numberOfWalks': booking.numberOfWalks,
            'ownerId': booking.ownerId, // Current user ID as ownerId
            'petName': booking.petName,
            'service': booking.service,
            'timeSlots': booking.timeSlots.toList(),
            'walkerId': booking.walkerId, // Walker ID
          });
    } catch (e) {
      print('Error saving booking for owner: $e');
    }
  }

  Future<void> _updateWalkerAvailability(String walkerId, BookingModel booking) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);
      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId) // Use walker's ID directly for availability
          .collection('availability')
          .doc(formattedDate)
          .update({
            'timeSlots': FieldValue.arrayRemove(booking.timeSlots.toList())
          });
    } catch (e) {
      print('Error updating walker availability: $e');
    }
  }
}
