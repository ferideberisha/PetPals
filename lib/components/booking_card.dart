import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/bookingModel.dart';
import 'package:petpals/controllers/user_controller.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/controllers/booking_controller.dart'; // Import the BookingController


class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final BookingController bookingController;

  const BookingCard({
    super.key,
    required this.booking,
    required this.bookingController,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(), // Fetch the role of the current user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading spinner while fetching
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Show an error message if there's an issue
        } else if (snapshot.hasData) {
          String role = snapshot.data!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service: ${booking.service}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Pet Name: ${booking.petName ?? 'No name provided'}'),
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(booking.date)}'),
                  Text('Time Slots: ${booking.timeSlots.join(', ')}'),
                  Text('Number of Walks: ${booking.numberOfWalks ?? 'Not specified'}'),
                  Text('Price: \$${booking.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  if (role == 'walker') // Show buttons only for walkers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await bookingController.acceptBooking(
                                booking: booking,
                                walkerId: booking.walkerId,
                                ownerId: booking.ownerId,
                              );
                            },
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Accept',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await bookingController.rejectBooking(
                                booking: booking,
                                walkerId: booking.walkerId,
                                ownerId: booking.ownerId,
                              );
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: 'Reject',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('No role data available')); // Handle case where role data is not available
        }
      },
    );
  }

  Future<String> _getUserRole() async {
    try {
      String userId = UserController().getCurrentUserId();
      UserModel? user = await UserController().getUser(userId);
      return user?.role ?? ''; // Return the user's role
    } catch (e) {
      print('Error fetching user role: $e');
      return ''; // Return an empty string in case of error
    }
  }
}

