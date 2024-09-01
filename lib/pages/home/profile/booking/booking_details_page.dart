import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/availability_controller.dart';
import 'package:petpals/controllers/booking_controller.dart';
import 'package:petpals/controllers/user_controller.dart';
import 'package:petpals/models/availabilityModel.dart';
import 'package:petpals/models/bookingModel.dart';
import 'package:petpals/pages/home/profile/booking/timeslots_display_page.dart';
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
  final UserController _userController =UserController();
  Map<DateTime, AvailabilityModel> _availabilityMap = {};
  Set<String> _selectedTimeSlots = {};
  double _totalPrice = 0.0; // Variable to store the total price
// Variable to store the selected date

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
      // Get current user's ID
      String currentUserId = await _userController.getCurrentUserId();

      // Fetch the pets of the current user
      List<Pet> pets = await _petController.getPets(currentUserId, "owner");

      setState(() {
        _pets = pets;
      });
    } catch (e) {
      print('Error fetching pets: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch pets. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
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
        // Initialize with all time slots as available
        availabilityMap[date] = AvailabilityModel(
          timeSlots: _getAllTimeSlots(), // Set all slots as available
          busySlots: [],
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

  Future<void> _selectDate(BuildContext context) async {
    final today = DateTime.now();

    // Show calendar to select a date
    final DateTime? selectedDay = await showDialog<DateTime>(
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
                  selectedDayPredicate: (day) =>
                      _dateController.text == DateFormat('yyyy-MM-dd').format(day),
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

                    // Close dialog and return the selected date
                    Navigator.of(context).pop(selectedDay);
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
                              color: availability.busyAllDay
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
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

    if (selectedDay != null) {
      // Proceed to select time slots after selecting a date
      final Set<String>? selectedSlots = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeSlotsDisplayPage(
            userId: widget.userId,
            date: selectedDay,
          ),
        ),
      );

      if (selectedSlots != null) {
        setState(() {
          _selectedTimeSlots = selectedSlots;
          _calculateTotalPrice(); // Calculate the total price when time slots are selected
        });
      }
    }
  }

void _calculateTotalPrice() {
  double? servicePrice;
  switch (_selectedService) {
    case 'Walking':
      servicePrice = widget.prices.walkingPrice;
      break;
    case 'Day Care':
      servicePrice = widget.prices.dayCarePrice;
      break;
    case 'House Sitting':
      servicePrice = widget.prices.houseSittingPrice;
      break;
    default:
      servicePrice = 0.0;
  }

  // Calculate price based on the selected service and time slots
  if (servicePrice != null) {
    _totalPrice = servicePrice * _selectedTimeSlots.length;
  } else {
    _totalPrice = 0.0; // Default price if service is not selected
  }

  setState(() {});
}


  Widget _buildNumberOfWalksDropdown() {
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
          // Reset time slots if number of walks changes
          _selectedTimeSlots.clear();
          _calculateTotalPrice(); // Recalculate price when number of walks changes
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
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(height: 16),
              if (_selectedService == 'Walking') ...[
                _buildNumberOfWalksDropdown(),
                const SizedBox(height: 16),
              ],
              _buildPetDropdown(),
              const SizedBox(height: 16),
              _buildTextField("Dates", Icons.calendar_today),
              const SizedBox(height: 16),
              if (_selectedTimeSlots.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected Time Slots:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _selectedTimeSlots.map((slot) {
                          return Chip(
                            label: Text(slot),
                            backgroundColor: const Color(0xFF967BB6),
                            labelStyle: const TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Total Price: €${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: MyButton(
        onTap: () {
          // Implement booking logic
          _bookAppointment();
        },
        text: 'Book',
        color: const Color(0xFF967BB6),
        textColor: Colors.white,
        borderColor: const Color(0xFF967BB6),
        borderWidth: 1.0,
        width: 390,
        height: 60,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

void _bookAppointment() async {
  // Check if all required fields are completed
  if (_selectedService == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a service.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (_selectedService == 'Walking' && _selectedNumberOfWalks == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select the number of walks.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (_selectedPet == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a pet.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (_dateController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a date.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (_selectedTimeSlots.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select time slots.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (_selectedService == 'Walking' && _selectedNumberOfWalks != null) {
    int numberOfWalks = int.parse(_selectedNumberOfWalks!);
    if (_selectedTimeSlots.length != numberOfWalks) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The number of selected time slots must match the number of walks.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

 // Retrieve current owner's ID
  String ownerId = await _userController.getCurrentUserId();

  // Generate a unique booking ID
  String bookingId = FirebaseFirestore.instance.collection('bookings').doc().id;

  // Create a booking model
  BookingModel booking = BookingModel(
    bookingId: bookingId,
    service: _selectedService!,
    petName: _selectedPet,
    date: DateFormat('yyyy-MM-dd').parse(_dateController.text),
    timeSlots: _selectedTimeSlots,
    numberOfWalks: _selectedNumberOfWalks != null ? int.parse(_selectedNumberOfWalks!) : null,
    ownerId: ownerId,
    walkerId: widget.userId,
    price: _totalPrice,
  );

  // Create booking controller instance
  BookingController bookingController = BookingController();
try {
    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(_dateController.text);
    AvailabilityModel? availability = await _availabilityController.getAvailability(widget.userId, selectedDate);

    if (availability == null) {
      // Create new availability with only selected slots as busy
      await _availabilityController.saveAvailability(
        widget.userId,
        selectedDate,
        AvailabilityModel(
          timeSlots: [], // No time slots to save since all are free
          busySlots: _selectedTimeSlots.toList(), // Only selected slots as busy
          busyAllDay: false,
        ),
      );
    } else {
      // Handle cases where availability exists
      Set<String> updatedBusySlots = Set.from(availability.busySlots);

      // Update busy slots and time slots correctly
      await _availabilityController.updateAvailability(
        widget.userId,
        selectedDate,
        updatedBusySlots.union(_selectedTimeSlots.toSet()), // Update busy slots
        Set.from(availability.timeSlots), // Ensure time slots are correctly handled
      );
    }

    // Save booking
    await bookingController.createBooking(
      role: widget.role,
      booking: booking,
      ownerId: ownerId,
      walkerId: widget.userId,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking successful!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking failed: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
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
          // Reset number of walks and time slots when service changes
          if (value != 'Walking') {
            _selectedNumberOfWalks = null;
            _selectedTimeSlots.clear();
          }
          // Recalculate price when service changes
          _calculateTotalPrice();
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
            style: const TextStyle(color: Color(0xFF424242), fontSize: 16),
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
