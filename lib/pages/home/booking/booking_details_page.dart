import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/availability_controller.dart';
import 'package:petpals/models/availabilityModel.dart';
import 'package:petpals/pages/home/booking/timeslots_display_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:petpals/components/service.dart';
import 'package:petpals/controllers/pet_controller.dart';
import 'package:petpals/models/priceModel.dart';
import 'package:petpals/models/petModel.dart';

class BookingDetailsPage extends StatefulWidget {
  final Prices prices;
  final String userId;
  final String role;

  const BookingDetailsPage({
    Key? key,
    required this.prices,
    required this.userId,
    required this.role,
  }) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  String? _selectedService;
  String? _selectedPet;
  String? _selectedNumberOfWalks;
  List<Pet> _pets = [];
  final PetController _petController = PetController();
  final TextEditingController _dateController = TextEditingController();
  final AvailabilityController _availabilityController = AvailabilityController();
  Map<DateTime, AvailabilityModel> _availabilityMap = {};

  @override
  void initState() {
    super.initState();
    _selectedService = null; // Ensure no service is selected initially
    _fetchPets();
    _fetchAvailability(); // Fetch availability data
  }

  List<String> _getAvailableServices() {
    final List<String> services = [];
    if (widget.prices.dayCareEnabled) services.add('Day Care');
    if (widget.prices.houseSittingEnabled) services.add('House Sitting');
    if (widget.prices.walkingEnabled) services.add('Walking');
    return services;
  }

  Future<void> _fetchPets() async {
    try {
      String userId = widget.userId;
      String role = widget.role;

      List<Pet> pets = await _petController.getPets(userId, role);

      setState(() {
        _pets = pets;
      });
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

Future<void> _fetchAvailability() async {
  try {
    final today = DateTime.now();
    final dates = List.generate(30, (index) => today.add(Duration(days: index)));
    Map<DateTime, AvailabilityModel> availabilityMap = {};

    for (DateTime date in dates) {
      AvailabilityModel? availability = await _availabilityController.getAvailability(widget.userId, date);

      if (availability != null) {
        availabilityMap[date] = availability;
      } else {
        // Date not in the database, show all time slots as available
        availabilityMap[date] = AvailabilityModel(
          timeSlots: _getAllTimeSlots(), // Set all slots as available
          busyAllDay: false,
        );
      }
    }

    setState(() {
      _availabilityMap = availabilityMap;
    });
  } catch (e) {
    print('Error fetching availability: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to fetch availability. Please try again later.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  List<String> _getAllTimeSlots() {
    return [
      "08:00-09:00",
      "09:30-10:30",
      "11:00-12:00",
      "12:30-13:30",
      "14:00-15:00",
      "15:30-16:30",
      "17:00-18:00",
      "18:30-19:30",
    ];
  }

  void _selectDate(BuildContext context) async {
    final today = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  firstDay: today,
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: today,
                  selectedDayPredicate: (day) => _dateController.text == DateFormat('yyyy-MM-dd').format(day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (selectedDay.isBefore(today)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You cannot select a date before today.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDay);
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeSlotsDisplayPage(
                          userId: widget.userId,
                          date: selectedDay,
                        ),
                      ),
                    );
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (_availabilityMap.containsKey(date)) {
                        final availability = _availabilityMap[date];
                        if (availability != null) {
                          return Positioned(
                            right: 1,
                            bottom: 1,
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: availability.busyAllDay ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 Widget _buildNumberOfWalksDropdown() {
  // Define the number of walks options
  final List<String> numberOfWalksOptions = ['1', '2', '3', '4', '5'];

  return DropdownButtonFormField<String>(
    value: _selectedNumberOfWalks,
    items: numberOfWalksOptions.map((walks) {
      return DropdownMenuItem<String>(
        value: walks,
        child: Text(
          walks,
          style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedNumberOfWalks = value;
      });
    },
    decoration: InputDecoration(
      labelText: "Number of Walks",
      labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      prefixIcon: const Icon(Icons.directions_walk, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    iconEnabledColor: Colors.black,
    style: const TextStyle(color: Color(0xFF9E9E9E)),
    dropdownColor: Colors.white,
  );
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text('Booking', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ServiceSection(
            dayCarePrice: widget.prices.dayCarePrice,
            houseSittingPrice: widget.prices.houseSittingPrice,
            walkingPrice: widget.prices.walkingPrice,
          ),
          const SizedBox(height: 16),
          _buildServiceDropdown(),
          const SizedBox(height: 0),
          if (_selectedService == 'Walking') ...[
            const SizedBox(height: 16),
            _buildNumberOfWalksDropdown(),
          ],
          const SizedBox(height: 16),
          _buildPetDropdown(),
          const SizedBox(height: 16),
          _buildTextField("Dates", Icons.calendar_today),
          const SizedBox(height: 16),
          // Wrap the button in a column with alignment
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: MyButton(
              onTap: () {},
              text: 'Book',
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



Widget _buildTextField(String label, IconData icon) {
  return GestureDetector(
    onTap: () {
      _selectDate(context);
    },
    child: AbsorbPointer(
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9E9E9E)), // Label text color
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF9E9E9E)), // Consistent border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF9E9E9E)), // Consistent border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF9E9E9E)), // Consistent border color
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        controller: _dateController,
           style: const TextStyle(color: Color(0xFF424242)), // Update text color
      ),
    ),
  );
}

Widget _buildServiceDropdown() {
  final availableServices = _getAvailableServices();

  return DropdownButtonFormField<String>(
    value: _selectedService,
    items: availableServices.map((service) {
      return DropdownMenuItem<String>(
        value: service,
        child: Text(
          service,
          style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedService = value;
        // Reset number of walks when service changes
        if (value != 'Walking') {
          _selectedNumberOfWalks = null;
        }
      });
    },
    decoration: InputDecoration(
      labelText: "Select service",
      labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      prefixIcon: const Icon(Icons.menu, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    iconEnabledColor: Colors.black,
    style: const TextStyle(color: Color(0xFF9E9E9E)),
    dropdownColor: Colors.white,
  );
}




 Widget _buildPetDropdown() {
  return DropdownButtonFormField<String>(
    value: _selectedPet,
    items: _pets.map((pet) {
      return DropdownMenuItem<String>(
        value: pet.name,
        child: Text(
          pet.name,
          style: const TextStyle(color:Color(0xFF424242), fontSize: 16),
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedPet = value;
      });
    },
    decoration: InputDecoration(
      labelText: "Select pet",
      labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      prefixIcon: const Icon(Icons.pets, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9E9E9E)),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    iconEnabledColor: Colors.black,
    style: const TextStyle(color: Color(0xFF9E9E9E)),
    dropdownColor: Colors.white,
  );
}

}
