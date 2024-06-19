import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/availabilityModel.dart'; // Assuming you have defined Availability and TimeSlot models
import 'package:petpals/components/custom_switch.dart';
import 'package:petpals/components/my_button.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _showAddButton = false;
  final Set<DateTime> _unavailableDates = {};
  Map<DateTime, Availability> _availabilityMap = {};
    Map<DateTime, List<String>> _partialAvailabilityDetails = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _showAddButton = true; // Show the add button when a date is selected
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              // Event loader to show unavailable dates
              eventLoader: (date) =>
                  _availabilityMap.containsKey(date) ? [_availabilityMap[date]!] : [],
            ),

            const SizedBox(height: 20.0),
            if (_showAddButton && _selectedDate != null)
              MyButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildBottomSheet();
                    },
                  );
                },
                text: '+ Add Busy Time',
                color: Colors.transparent,
                textColor: const Color(0xFF967BB6),
                borderColor: const Color(0xFF967BB6),
                borderWidth: 1.0,
                width: 390,
                height: 60,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    TextEditingController _fromController = TextEditingController();
    TextEditingController _toController = TextEditingController();
    bool _busyAllDaySwitch = false; // Track all-day busy switch state

return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectTime(context, _fromController);
                      },
                      child: IgnorePointer(
                        child: TextField(
                          controller: _fromController,
                          decoration: const InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectTime(context, _toController);
                      },
                      child: IgnorePointer(
                        child: TextField(
                          controller: _toController,
                          decoration: const InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            CustomSwitchTile(
              title: 'Busy all day',
              initialValue: _busyAllDaySwitch,
              onChanged: (value) {
                setState(() {
                  _busyAllDaySwitch = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_busyAllDaySwitch) {
                  _markDayAsBusyAllDay();
                } else {
                  _addTimeSlot(_fromController.text, _toController.text);
                }
                _fromController.clear();
                _toController.clear();
                Navigator.pop(context); // Close the bottom sheet
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20.0),
            if (_partialAvailabilityDetails.containsKey(_selectedDate))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _partialAvailabilityDetails[_selectedDate]!
                    .map((detail) => Text(detail))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }


  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      String formattedTime = DateFormat.Hm().format(DateTime(2021, 1, 1, selectedTime.hour, selectedTime.minute));
      controller.text = formattedTime;
    }
  }

  void _addTimeSlot(String from, String to) async {
    if (_selectedDate != null) {
      try {
        // Parse the time strings
        TimeOfDay fromTime = TimeOfDay(
          hour: int.parse(from.split(":")[0]),
          minute: int.parse(from.split(":")[1]),
        );
        TimeOfDay toTime = TimeOfDay(
          hour: int.parse(to.split(":")[0]),
          minute: int.parse(to.split(":")[1]),
        );

        // Create DateTime objects for the selected date with the parsed times
        DateTime fromDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          fromTime.hour,
          fromTime.minute,
        );

        DateTime toDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          toTime.hour,
          toTime.minute,
        );

        TimeSlot newTimeSlot = TimeSlot(from: fromDateTime, to: toDateTime);

        DocumentReference availabilityRef =
            _firestore.collection('availability').doc(_selectedDate!.toIso8601String());

        DocumentSnapshot snapshot = await availabilityRef.get();
        if (snapshot.exists) {
          await availabilityRef.update({
            'timeSlots': FieldValue.arrayUnion([newTimeSlot.toMap()]),
          });
        } else {
          await availabilityRef.set({
            'date': _selectedDate!,
            'timeSlots': [newTimeSlot.toMap()],
            'isBusyAllDay': false,
          });
        }

        _unavailableDates.add(_selectedDate!);
        setState(() {
          // Update state to reflect new time slot
          _availabilityMap[_selectedDate!] = Availability(
            date: _selectedDate!,
            timeSlots: [newTimeSlot],
            isBusyAllDay: false,
          );
        });
      } catch (e) {
        print('Error adding time slot: $e');
      }
    }
  }

  void _markDayAsBusyAllDay() async {
    if (_selectedDate != null) {
      try {
        Availability allDayAvailability = Availability(
          date: _selectedDate!,
          timeSlots: [],
          isBusyAllDay: true,
        );

        await _updateAvailability(allDayAvailability);

        setState(() {
          _availabilityMap[_selectedDate!] = allDayAvailability;
          _unavailableDates.add(_selectedDate!);
        });
      } catch (e) {
        print('Error marking day as busy all day: $e');
      }
    }
  }

  Future<void> _updateAvailability(Availability availability) async {
    try {
      DocumentReference availabilityRef =
          _firestore.collection('availability').doc(availability.date.toIso8601String());

      DocumentSnapshot snapshot = await availabilityRef.get();
      if (snapshot.exists) {
        await availabilityRef.update({
          'timeSlots': availability.timeSlots.map((slot) => slot.toMap()).toList(),
          'isBusyAllDay': availability.isBusyAllDay,
        });
      } else {
        await availabilityRef.set({
          'date': availability.date,
          'timeSlots': availability.timeSlots.map((slot) => slot.toMap()).toList(),
          'isBusyAllDay': availability.isBusyAllDay,
        });
      }

      print('Availability updated successfully');
    } catch (e) {
      print('Error updating availability: $e');
      throw e;
    }
  }
}
