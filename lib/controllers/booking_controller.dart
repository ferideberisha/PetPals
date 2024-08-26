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
          .doc() // Auto-generated document ID
          .set({
            'date': formattedDate,
            'numberOfWalks': booking.numberOfWalks,
            'ownerId': booking.ownerId,
            'petName': booking.petName,
            'service': booking.service,
            'timeSlots': booking.timeSlots.toList(),
            'walkerId': booking.walkerId,
            'price': booking.price,
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
          .doc(ownerId) // Owner ID as document path
          .collection('booking')
          .doc('sent')
          .collection('outgoingRequest')
          .doc() // Auto-generated document ID
          .set({
            'date': formattedDate,
            'numberOfWalks': booking.numberOfWalks,
            'ownerId': booking.ownerId,
            'petName': booking.petName,
            'service': booking.service,
            'timeSlots': booking.timeSlots.toList(),
            'walkerId': booking.walkerId,
            'price': booking.price,
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

Future<void> acceptBooking(String bookingId, String walkerId, String ownerId) async {
  try {
    DocumentSnapshot bookingSnapshot = await _firestore.collection('users')
        .doc(walkerId)
        .collection('walkerInfo')
        .doc(walkerId)
        .collection('booking')
        .doc('received')
        .collection('incomingRequest')
        .doc(bookingId)
        .get();

    if (bookingSnapshot.exists) {
      Map<String, dynamic> bookingData = bookingSnapshot.data() as Map<String, dynamic>;

      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId)
          .collection('booking')
          .doc('received')
          .collection('acceptedRequest')
          .doc(bookingId)
          .set(bookingData);

      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId)
          .collection('booking')
          .doc('received')
          .collection('incomingRequest')
          .doc(bookingId)
          .delete();

      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(ownerId)
          .collection('booking')
          .doc('sent')
          .collection('outgoingRequest')
          .doc(bookingId)
          .update({'status': 'accepted'});

      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(ownerId)
          .collection('booking')
          .doc('sent')
          .collection('outgoingRequest')
          .doc(bookingId)
          .delete();

      await _updateWalkerAvailability(walkerId, BookingModel.fromMap(bookingData));
    } else {
      print('Error accepting booking: Booking document does not exist');
    }
  } catch (e) {
    print('Error accepting booking: $e');
  }
}

Future<void> rejectBooking(String bookingId, String walkerId, String ownerId) async {
  try {
    DocumentSnapshot bookingSnapshot = await _firestore.collection('users')
        .doc(walkerId)
        .collection('walkerInfo')
        .doc(walkerId)
        .collection('booking')
        .doc('received')
        .collection('incomingRequest')
        .doc(bookingId)
        .get();

    if (bookingSnapshot.exists) {
      Map<String, dynamic> bookingData = bookingSnapshot.data() as Map<String, dynamic>;

      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId)
          .collection('booking')
          .doc('received')
          .collection('rejectedRequest')
          .doc(bookingId)
          .set(bookingData);

      await _firestore.collection('users')
          .doc(walkerId)
          .collection('walkerInfo')
          .doc(walkerId)
          .collection('booking')
          .doc('received')
          .collection('incomingRequest')
          .doc(bookingId)
          .delete();

      await _firestore.collection('users')
          .doc(ownerId)
          .collection('ownerInfo')
          .doc(ownerId)
          .collection('booking')
          .doc('sent')
          .collection('outgoingRequest')
          .doc(bookingId)
          .delete();
    } else {
      print('Error rejecting booking: Booking document does not exist');
    }
  } catch (e) {
    print('Error rejecting booking: $e');
  }
}


  }
