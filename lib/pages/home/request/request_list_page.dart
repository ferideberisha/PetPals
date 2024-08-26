import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpals/components/booking_card.dart';
import 'package:petpals/controllers/booking_controller.dart'; // Import BookingController
import 'package:petpals/models/bookingModel.dart';

class RequestList extends StatelessWidget {
  final String status;
  final BookingController bookingController; // Add BookingController field
  final String currentUserRole;

  const RequestList({
    super.key,
    required this.status,
    required this.bookingController, required this.currentUserRole, // Initialize BookingController in constructor
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _getBookingStream(user.uid, status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No bookings found'));
        }

        final bookings = snapshot.data!.docs.map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>)).toList();

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
  final booking = bookings[index];
  return BookingCard(
    booking: booking,
    bookingController: bookingController,
    bookingStatus: status, // Pass the status from the RequestList
  );
},

        );
      },
    );
  }

 Stream<QuerySnapshot> _getBookingStream(String userId, String status) {
  String collectionPath;
  String bookingType;
  String documentPath;

  if (status == 'Outgoing') {
    collectionPath = 'ownerInfo';
    bookingType = 'sent';
    documentPath = 'outgoingRequest';
  } else if (status == 'Incoming') {
    collectionPath = 'walkerInfo';
    bookingType = 'received';
    documentPath = 'incomingRequest';
  } else if (status == 'Accepted') {
    if (currentUserRole == 'walker') {
      collectionPath = 'walkerInfo';
      bookingType = 'received';
      documentPath = 'acceptedRequest';
    } else {
      collectionPath = 'ownerInfo';
      bookingType = 'sent';
      documentPath = 'acceptedRequest';
    }
  } else if (status == 'Rejected') {
    if (currentUserRole == 'walker') {
      collectionPath = 'walkerInfo';
      bookingType = 'received';
      documentPath = 'rejectedRequest';
    } else {
      collectionPath = 'ownerInfo';
      bookingType = 'sent';
      documentPath = 'rejectedRequest';
    }
  } else {
    throw ArgumentError('Invalid status: $status');
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection(collectionPath)
      .doc(userId)
      .collection('booking')
      .doc(bookingType)
      .collection(documentPath)
      .snapshots();
}

}
