import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petpals/controllers/availability_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:petpals/models/availabilityModel.dart';
import 'package:petpals/components/custom_switch.dart';
import 'package:petpals/components/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCalendar extends StatefulWidget {
  final String userId;
  final String role;

  const MyCalendar({Key? key, required this.userId, required this.role}) : super(key: key);

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _showAddButton = false;
  final Set<DateTime> _unavailableDates = {};
  Map<DateTime, Availability> _availabilityMap = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final AvailabilityController _availabilityController;

  @override
  void initState() {
    super.initState();
    _availabilityController = AvailabilityController();
    _fetchAvailability();
  }

  Future<void> _fetchAvailability() async {
    try {
      final path = 'users/${widget.userId}/walkerInfo/${widget.userId}/availability';
      QuerySnapshot querySnapshot = await _firestore.collection(path).get();

      _availabilityMap.clear();
      _unavailableDates.clear();

      print('Fetched ${querySnapshot.docs.length} documents');

      querySnapshot.docs.forEach((doc) {
        print('Document ID: ${doc.id}');
        Availability availability = Availability.fromMap(doc.data() as Map<String, dynamic>);
        print('Availability: $availability');
        _availabilityMap[availability.date] = availability;
        if (availability.isBusyAllDay) {
          _unavailableDates.add(availability.date);
        }
      });

      setState(() {}); // Trigger UI refresh
    } catch (e) {
      print('Error fetching availability: $e');
      // Optionally, show an error message to the user
    }
  }

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
              eventLoader: (day) {
                if (_availabilityMap.containsKey(day)) {
                  Availability availability = _availabilityMap[day]!;
                  if (availability.isBusyAllDay) {
                    return [availability];
                  } else {
                    return availability.timeSlots;
                  }
                } else {
                  return [];
                }
              },
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
    bool _busyAllDaySwitch = false;

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
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20.0),
            if (_selectedDate != null && _availabilityMap.containsKey(_selectedDate!))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (TimeSlot slot in _availabilityMap[_selectedDate!]!.timeSlots)
                    _buildTimeSlotWidget(slot),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotWidget(TimeSlot slot) {
    String fromTime = DateFormat.Hm().format(slot.from);
    String toTime = DateFormat.Hm().format(slot.to);
    return Text('Busy from $fromTime to $toTime');
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
        TimeOfDay fromTime = TimeOfDay(
          hour: int.parse(from.split(":")[0]),
          minute: int.parse(from.split(":")[1]),
        );
        TimeOfDay toTime = TimeOfDay(
          hour: int.parse(to.split(":")[0]),
          minute: int.parse(to.split(":")[1]),
        );

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

        await _availabilityController.addTimeSlot(widget.userId, _selectedDate!.toIso8601String(), newTimeSlot);

        setState(() {
          if (_availabilityMap.containsKey(_selectedDate!)) {
            _availabilityMap[_selectedDate!]!.timeSlots.add(newTimeSlot);
          } else {
            _availabilityMap[_selectedDate!] = Availability(
              date: _selectedDate!,
              timeSlots: [newTimeSlot],
              isBusyAllDay: false,
            );
          }
        });
      } catch (e) {
        print('Error adding time slot: $e');
        // Optionally, show an error message to the user
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

        await _availabilityController.updateAvailability(widget.userId, _selectedDate!.toIso8601String(), allDayAvailability);

        setState(() {
          _availabilityMap[_selectedDate!] = allDayAvailability;
          _unavailableDates.add(_selectedDate!);
        });
      } catch (e) {
        print('Error marking day as busy all day: $e');
        // Optionally, show an error message to the user
      }
    }
  }
}
