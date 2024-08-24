import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/profile/business/availability/timeslots_page.dart';
import 'package:table_calendar/table_calendar.dart';

class AvailabilityPage extends StatefulWidget {
  final String userId;
  final String role;
  const AvailabilityPage({super.key, required this.userId, required this.role});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Availability'),
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
                _onDaySelected(selectedDay, focusedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  if (day.isBefore(DateTime.now())) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return null; // Use the default builder for other days
                },
              ),
            ),
            const SizedBox(height: 20.0),
            // Edit Calendar button
            MyButton(
              onTap: () {
                // Navigate to the TimeSlotsPage with the selected date
                if (_selectedDate != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeSlotsPage(
                        userId: widget.userId,
                        date: _selectedDate!,
                      ),
                    ),
                  );
                } else {
                  // Show a message to select a date first
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date to edit.'),
                    ),
                  );
                }
              },
              text: 'Edit Calendar',
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }
}
