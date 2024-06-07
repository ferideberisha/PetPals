import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

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
            MyButton(
              onTap: () {
                setState(() {
                  _isEditing = !_isEditing;
                  _selectedDate = null;
                });
              },
              text: _isEditing ? 'Add Bussiness day' : 'Edit Calendar',
              color: Colors.transparent,
              textColor: const Color(0xFF967BB6),
              borderColor: const Color(0xFF967BB6),
              borderWidth: 1.0,
              width: 390,
              height: 60,
            ),
            if (_isEditing && _selectedDate != null)
              _buildBottomSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Expanded(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(), // Prevent scrolling of the parent ListView
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Add Time Period'),
            trailing: const Icon(Icons.add),
            onTap: () {
              // Handle adding time period
            },
          ),
          SwitchListTile(
            title: const Text('I\'m Busy All Day'),
            value: false, // Set initial switch value
            onChanged: (value) {
              // Handle switch change
            },
          ),
          MyButton(
            onTap: () {
              // Handle save changes
            },
            text: 'Save Changes',
            color: const Color(0xFF967BB6),
            textColor: Colors.white,
            borderColor: const Color(0xFF967BB6),
            borderWidth: 1.0,
            height: 60,
          ),
        ],
      ),
    );
  }
}