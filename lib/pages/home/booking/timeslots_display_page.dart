import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/availability_controller.dart';
import 'package:petpals/models/availabilityModel.dart';

class TimeSlotsDisplayPage extends StatefulWidget {
  final String userId;
  final DateTime date;

  const TimeSlotsDisplayPage({Key? key, required this.userId, required this.date}) : super(key: key);

  @override
  _TimeSlotsDisplayPageState createState() => _TimeSlotsDisplayPageState();
}

class _TimeSlotsDisplayPageState extends State<TimeSlotsDisplayPage> {
  final AvailabilityController _availabilityController = AvailabilityController();
  List<String> _availableTimeSlots = [];
  Set<String> selectedSlots = {};

  @override
  void initState() {
    super.initState();
    _fetchAvailableTimeSlots();
  }

  Future<void> _fetchAvailableTimeSlots() async {
    try {
      AvailabilityModel? availability = await _availabilityController.getAvailability(widget.userId, widget.date);

      if (availability != null) {
        if (availability.busyAllDay) {
          _availableTimeSlots = []; // No slots available
        } else {
          _availableTimeSlots = availability.availableSlots;
        }
      } else {
        // Date not in the database, show all time slots as available
        _availableTimeSlots = _getAllTimeSlots(); // Return all possible time slots
      }

      setState(() {}); // Update UI after fetching time slots
    } catch (e) {
      print('Error fetching available time slots: $e');
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

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slots for $formattedDate', style: const TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: [
          _availableTimeSlots.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'There are no free time slots for this date.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select time slots to book:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3.5,
                          ),
                          itemCount: _availableTimeSlots.length,
                          itemBuilder: (context, index) {
                            String slot = _availableTimeSlots[index];
                            bool isSelected = selectedSlots.contains(slot);

                            return MyButton(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedSlots.remove(slot);
                                  } else {
                                    selectedSlots.add(slot);
                                  }
                                });
                              },
                              text: slot,
                              color: isSelected ? const Color(0xFFCAADEE) : Colors.white,
                              textColor: Colors.black,
                              borderColor: const Color(0xFFCAADEE),
                              borderWidth: 1,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          if (_availableTimeSlots.isNotEmpty) // Show button only if there are available slots
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Center(
                  child: MyButton(
                    onTap: () {
                      // Handle confirmation
                      _confirmBooking();
                    },
                    text: 'Confirm',
                    color: const Color(0xFF967BB6),
                    textColor: Colors.white,
                    borderColor: const Color(0xFF967BB6),
                    borderWidth: 1.0,
                    width: 390,
                    height: 60,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking() async {
    // Example for saving the booking
    // Implement the logic to save the selected slots and confirm the booking
    print('Selected slots: $selectedSlots');
    try {
      // Save booking logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Close the page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to confirm booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
