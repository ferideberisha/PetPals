import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/business/my_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({Key? key}) : super(key: key);

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  bool _isEditing = false;
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
              onDaySelected: _isEditing ? _onDaySelected : null,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
            ),
            const SizedBox(height: 20.0),
           // Add Pet button
            MyButton(
              onTap: () {
                // Navigate to the AddPetPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCalendar()),
                );
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
