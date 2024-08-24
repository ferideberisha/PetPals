// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:petpals/models/availabilityModel.dart';

// class MyCalendar extends StatefulWidget {
//   final String userId;
//   final String role;

//   const MyCalendar({Key? key, required this.userId, required this.role}) : super(key: key);

//   @override
//   State<MyCalendar> createState() => _MyCalendarState();
// }

// class _MyCalendarState extends State<MyCalendar> {
//   DateTime? _selectedDate;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   Map<DateTime, Availability> _availabilityMap = {};

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Calendar'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TableCalendar(
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: DateTime.now(),
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDate = selectedDay;
//                 });
//               },
//               onFormatChanged: (format) {
//                 if (_calendarFormat != format) {
//                   setState(() {
//                     _calendarFormat = format;
//                   });
//                 }
//               },
//               eventLoader: (day) {
//                 if (_availabilityMap.containsKey(day)) {
//                   Availability availability = _availabilityMap[day]!;
//                   if (availability.isBusyAllDay) {
//                     return [availability];
//                   } else {
//                     return availability.timeSlots;
//                   }
//                 } else {
//                   return [];
//                 }
//               },
//               calendarBuilders: CalendarBuilders(
//                 defaultBuilder: (context, day, focusedDay) {
//                   if (day.isBefore(DateTime.now())) {
//                     return Center(
//                       child: Text(
//                         '${day.day}',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     );
//                   }
//                   return null; // Use the default builder for other days
//                 },
//               ),
//             ),
//             const SizedBox(height: 20.0)
//           ],
//         ),
//       ),
//     );
//   }
// }
