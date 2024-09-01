import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/bookingModel.dart';
import 'package:petpals/controllers/user_controller.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/controllers/booking_controller.dart'; // Import the BookingController

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final BookingController bookingController;
  final String bookingStatus; // Field to store booking status

  const BookingCard({
    super.key,
    required this.booking,
    required this.bookingController,
    required this.bookingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserRoleAndNames(), // Fetch the role and names of the current user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show a loading spinner while fetching
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Show an error message if there's an issue
        } else if (snapshot.hasData) {
          String role = snapshot.data!['role']!;
          String walkerName = snapshot.data!['walkerName']!;
          String ownerName = snapshot.data!['ownerName']!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the appropriate name based on the user's role
                  if (role == 'owner')
                    Text('Walker: $walkerName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (role == 'walker')
                    Text('Owner: $ownerName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),
                  Text('Service: ${booking.service}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Pet Name: ${booking.petName ?? 'No name provided'}'),
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(booking.date)}'),
                  Text('Time Slots: ${booking.timeSlots.join(', ')}'),
                  Text('Number of Walks: ${booking.numberOfWalks ?? 'Not specified'}'),
                  Text('Price: \$${booking.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),

                  // Show buttons only if the role is walker and the booking is in the incoming requests
                  if (role == 'walker' && bookingStatus == 'Incoming')
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
          return const Center(child: Text('No role data available')); // Handle case where role data is not available
        }
      },
    );
  }

  Future<Map<String, String>> _getUserRoleAndNames() async {
    try {
      String userId = UserController().getCurrentUserId();
      UserModel? user = await UserController().getUser(userId);

      // Fetch the names of the walker and owner
      UserModel? walker = await UserController().getUser(booking.walkerId);
      UserModel? owner = await UserController().getUser(booking.ownerId);

      return {
        'role': user?.role ?? '',
        'walkerName': '${walker?.firstName ?? 'Unknown'} ${walker?.lastName ?? 'Unknown'}',
        'ownerName': '${owner?.firstName ?? 'Unknown'} ${owner?.lastName ?? 'Unknown'}',
      };
    } catch (e) {
      print('Error fetching user role and names: $e');
      return {
        'role': '',
        'walkerName': 'Unknown',
        'ownerName': 'Unknown',
      };
    }
  }
}
