import 'package:flutter/material.dart';
import 'package:petpals/components/custom_switch.dart';
import 'package:petpals/components/my_button.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _showAddButton = false;
  bool _busyAllDay = false; // Define the variable to track the state of the switch
  final Set<DateTime> _unavailableDates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My calendar'),
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
                  _showAddButton = true;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              // Pass the set of unavailable dates to the calendar
              daysOfWeekVisible: true,
              weekendDays: const [DateTime.saturday],
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              eventLoader: (date) => _unavailableDates.contains(date)
                  ? [_unavailableDates]
                  : [],
            ),
            const SizedBox(height: 20.0),
            if (_showAddButton)
              MyButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildBottomSheet();
                    },
                  );
                },
                text: '+ Add Busyness Time',
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
    // Create a list to hold the text controllers for each text field
    List<TextEditingController> controllers = [];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Text fields for specifying time periods
            Column(
              children: controllers.map((controller) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Switch to indicate if busy all day
            CustomSwitchTile(
              initialValue: _busyAllDay,
              onChanged: (value) {
                setState(() {
                  _busyAllDay = value;
                  // If busy all day is toggled, update selected date availability
                  if (value) {
                    _unavailableDates.add(_selectedDate!);
                  } else {
                    _unavailableDates.remove(_selectedDate!);
                  }
                });
              },
              title: 'Busy all day',
            ),
            const SizedBox(height: 10.0),

            // Button to save changes
            MyButton(
              onTap: () {
                // Handle save changes
                Navigator.pop(context); // Close the bottom sheet
              },
              text: 'Save Changes',
              color: const Color(0xFF967BB6),
              textColor: Colors.white,
              borderColor: const Color(0xFF967BB6),
              borderWidth: 1.0,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
