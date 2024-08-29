import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/availability_controller.dart';
import 'package:petpals/models/availabilityModel.dart';

class TimeSlotsPage extends StatefulWidget {
  final String userId;
  final DateTime date;

  const TimeSlotsPage({Key? key, required this.userId, required this.date}) : super(key: key);

  @override
  _TimeSlotsPageState createState() => _TimeSlotsPageState();
}

class _TimeSlotsPageState extends State<TimeSlotsPage> {
  List<String> timeSlots = [
    "08:00-09:00", "09:30-10:30", "11:00-12:00", "12:30-13:30",
    "14:00-15:00", "15:30-16:30", "17:00-18:00", "18:30-19:30"
  ]; 
  Set<String> selectedSlots = {}; // Slots selected as busy by the walker
  Set<String> bookingSlots = {}; // Slots busy due to bookings
  bool _busyAllDaySwitch = false; 

  final AvailabilityController _availabilityController = AvailabilityController();

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    AvailabilityModel? availability = await _availabilityController.getAvailability(widget.userId, widget.date);

    if (availability != null) {
      setState(() {
        bookingSlots = Set<String>.from(availability.busySlots); // Slots from bookings
        selectedSlots = Set<String>.from(availability.timeSlots); // Walkers' busy slots
        _busyAllDaySwitch = selectedSlots.length == timeSlots.length;
      });
    } else {
      setState(() {
        selectedSlots = {};
        bookingSlots = {};
        _busyAllDaySwitch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slots for $formattedDate', style: const TextStyle(fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select time slots when you are busy:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20.0),
            GridView.builder(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(), 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3.5,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                String slot = timeSlots[index];
                bool isSelected = selectedSlots.contains(slot);
                bool isBooking = bookingSlots.contains(slot);

                return MyButton(
                  onTap: () {
                    setState(() {
                      if (_busyAllDaySwitch) return;
                      if (isBooking) return; // Do not allow selecting or deselecting booking slots
                      if (selectedSlots.contains(slot)) {
                        selectedSlots.remove(slot);
                      } else {
                        selectedSlots.add(slot);
                      }
                      _busyAllDaySwitch = selectedSlots.length == timeSlots.length;
                    });
                  },
                  text: slot,
                  color: isBooking ? Colors.red : (isSelected ? const Color(0xFFCAADEE) : Colors.white),
                  textColor: Colors.black,
                  borderColor: const Color(0xFFCAADEE),
                  borderWidth: 1,
                );
              },
            ),
            SwitchListTile(
              title: const Text('Busy all day'),
              value: _busyAllDaySwitch,
              onChanged: (value) {
                setState(() {
                  _busyAllDaySwitch = value;
                  if (value) {
                    selectedSlots = Set<String>.from(timeSlots);
                  } else {
                    selectedSlots.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 320.0),
            Center(
              child: MyButton(
                onTap: () {
                  _saveAvailability();
                },
                text: 'Save',
                color: const Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: const Color(0xFF967BB6),
                borderWidth: 1.0,
                width: 390,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAvailability() async {
    final availability = AvailabilityModel(
      timeSlots: _busyAllDaySwitch 
        ? List<String>.from(timeSlots) // Save all slots in timeSlots if busy all day
        : selectedSlots.toList(), // Otherwise, save only selected slots
      busySlots: bookingSlots.toList(), // Keep only the slots busy due to bookings
      busyAllDay: _busyAllDaySwitch,
    );

    try {
      await _availabilityController.saveAvailability(widget.userId, widget.date, availability);
      // Show a confirmation message after successful save
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
