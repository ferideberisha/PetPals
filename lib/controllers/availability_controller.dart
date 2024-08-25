import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/availabilityModel.dart';
import 'package:petpals/models/bookingModel.dart';

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

  Future<void> createBooking(String userId, DateTime date, String selectedSlot) async {
  try {
    // Get the current availability
    AvailabilityModel? availability = await getAvailability(userId, date);
    
    // Update availability by marking the selected slot as booked
    if (availability != null) {
      availability.timeSlots.add(selectedSlot);
    } else {
      availability = AvailabilityModel(timeSlots: [selectedSlot]);
    }

    // Save the updated availability
    await saveAvailability(userId, date, availability);

    // Save the booking details separately in the database
    BookingModel booking = BookingModel(
      userId: userId,
      date: date,
      timeSlot: selectedSlot,
      status: 'confirmed',
    );
    await saveBooking(booking);
  } catch (e) {
    print('Error creating booking: $e');
  }
}

Future<void> saveBooking(BookingModel booking) async {
  try {
    String formattedDate = DateFormat('yyyy-MM-dd').format(booking.date);
    await _firestore.collection('bookings')
        .doc(booking.userId)
        .collection('userBookings')
        .doc('$formattedDate-${booking.timeSlot}')
        .set(booking.toMap());
  } catch (e) {
    print('Error saving booking: $e');
  }
}

}
