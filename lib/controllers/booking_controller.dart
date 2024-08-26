import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/bookingModel.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking({
    required String ownerId,
    required String walkerId,
    required BookingModel booking, 
    required String role,
  }) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);

      await Future.wait([
        _saveBookingForWalker(walkerId, booking, formattedDate),
        _saveBookingForOwner(ownerId, booking, formattedDate),
      ]);

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
        .doc(walkerId)
        .collection('booking')
        .doc('received')
        .collection('incomingRequest')
        .doc(booking.bookingId) // Use bookingId as the document ID
        .set(booking.toMap());
  } catch (e) {
    print('Error saving booking for walker: $e');
  }
}

Future<void> _saveBookingForOwner(String ownerId, BookingModel booking, String formattedDate) async {
  try {
    await _firestore.collection('users')
        .doc(ownerId)
        .collection('ownerInfo')
        .doc(ownerId)
        .collection('booking')
        .doc('sent')
        .collection('outgoingRequest')
        .doc(booking.bookingId) // Use bookingId as the document ID
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
          .doc(walkerId)
          .collection('availability')
          .doc(formattedDate)
          .update({
            'timeSlots': FieldValue.arrayRemove(booking.timeSlots.toList())
          });
    } catch (e) {
      print('Error updating walker availability: $e');
    }
  }

  Future<void> acceptBooking({
    required BookingModel booking,
    required String walkerId,
    required String ownerId,
  }) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);

      // Update booking status in Firestore
      await Future.wait([
        _moveBookingToAcceptedForWalker(walkerId, booking, formattedDate),
        _moveBookingToAcceptedForOwner(ownerId, booking, formattedDate),
      ]);
      
      // Remove the booking from the incoming requests for the walker
      await _removeBookingFromIncomingRequests(walkerId, booking, formattedDate);

      // Remove the booking from the outgoing requests for the owner
      await _removeBookingFromOutgoingRequests(ownerId, booking, formattedDate);

    } catch (e) {
      print('Error accepting booking: $e');
    }
  }

  Future<void> _moveBookingToAcceptedForWalker(String walkerId, BookingModel booking, String formattedDate) async {
    try {
      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId)
          .collection('booking')
          .doc('received')
          .collection('acceptedRequest')
          .doc() // Auto-generated document ID
          .set(booking.toMap());
    } catch (e) {
      print('Error moving booking to accepted for walker: $e');
    }
  }

  Future<void> _moveBookingToAcceptedForOwner(String ownerId, BookingModel booking, String formattedDate) async {
    try {
      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(ownerId)
          .collection('booking')
          .doc('sent')
          .collection('acceptedRequest')
          .doc() // Auto-generated document ID
          .set(booking.toMap());
    } catch (e) {
      print('Error moving booking to accepted for owner: $e');
    }
  }

  Future<void> rejectBooking({
    required BookingModel booking,
    required String walkerId,
    required String ownerId,
  }) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);

      // Update booking status in Firestore
      await Future.wait([
        _moveBookingToRejectedForWalker(walkerId, booking, formattedDate),
        _moveBookingToRejectedForOwner(ownerId, booking, formattedDate),
      ]);
      
      // Remove the booking from the incoming requests for the walker
      await _removeBookingFromIncomingRequests(walkerId, booking, formattedDate);

    } catch (e) {
      print('Error rejecting booking: $e');
    }
  }

  Future<void> _moveBookingToRejectedForWalker(String walkerId, BookingModel booking, String formattedDate) async {
    try {
      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId)
          .collection('booking')
          .doc('received')
          .collection('rejectedRequest')
          .doc() // Auto-generated document ID
          .set(booking.toMap());
    } catch (e) {
      print('Error moving booking to rejected for walker: $e');
    }
  }

  Future<void> _moveBookingToRejectedForOwner(String ownerId, BookingModel booking, String formattedDate) async {
    try {
      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(ownerId)
          .collection('booking')
          .doc('sent')
          .collection('rejectedRequest')
          .doc() // Auto-generated document ID
          .set(booking.toMap());
    } catch (e) {
      print('Error moving booking to rejected for owner: $e');
    }
  }


Future<void> _removeBookingFromIncomingRequests(String walkerId, BookingModel booking, String formattedDate) async {
  try {
    await _firestore.collection('users')
        .doc(walkerId)
        .collection('walkerInfo')
        .doc(walkerId)
        .collection('booking')
        .doc('received')
        .collection('incomingRequest')
        .doc(booking.bookingId) // Use bookingId as the document ID
        .delete();
  } catch (e) {
    print('Error removing booking from incoming requests: $e');
  }
}

Future<void> _removeBookingFromOutgoingRequests(String ownerId, BookingModel booking, String formattedDate) async {
  try {
    await _firestore.collection('users')
        .doc(ownerId)
        .collection('ownerInfo')
        .doc(ownerId)
        .collection('booking')
        .doc('sent')
        .collection('outgoingRequest')
        .doc(booking.bookingId) // Use bookingId as the document ID
        .delete();
  } catch (e) {
    print('Error removing booking from outgoing requests: $e');
  }
}

}
