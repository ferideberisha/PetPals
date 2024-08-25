import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/bookingModel.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking({
    required String userId,
    required String role,
    required BookingModel booking,
  }) async {
    try {
      // Save booking details based on role
      if (role == 'walker') {
        await _saveBookingForWalker(userId, booking);
      } else if (role == 'owner') {
        await _saveBookingForOwner(userId, booking);
      }
    } catch (e) {
      print('Error creating booking: $e');
    }
  }

  Future<void> _saveBookingForWalker(String walkerId, BookingModel booking) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);
      
      // Generate a unique booking document ID
      String bookingDocId = _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(booking.userId)
          .collection('booking')
          .doc('incomingRequest')
          .collection(formattedDate)
          .doc().id;
      
      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(booking.userId) // Assuming userId is the owner's ID
          .collection('booking')
          .doc('incomingRequest')
          .collection(formattedDate)
          .doc(bookingDocId)
          .set(booking.toMap());

      // Update the walker's availability
      await _updateWalkerAvailability(walkerId, booking);
    } catch (e) {
      print('Error saving booking for walker: $e');
    }
  }

  Future<void> _saveBookingForOwner(String ownerId, BookingModel booking) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);
      
      // Generate a unique booking document ID
      String bookingDocId = _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(booking.userId)
          .collection('booking')
          .doc('outgoingRequest')
          .collection(formattedDate)
          .doc().id;
      
      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(booking.userId) // Assuming userId is the walker's ID
          .collection('booking')
          .doc('outgoingRequest')
          .collection(formattedDate)
          .doc(bookingDocId)
          .set(booking.toMap());
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
          .doc(walkerId) // Use the walker's ID directly for availability
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
