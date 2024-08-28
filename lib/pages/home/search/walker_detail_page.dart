import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/service.dart';
import 'package:petpals/controllers/aboutme_controller.dart';
import 'package:petpals/controllers/price_controller.dart';
import 'package:petpals/models/priceModel.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/pages/home/booking/booking_details_page.dart';
import 'package:table_calendar/table_calendar.dart';

class WalkerDetailPage extends StatefulWidget {
  final UserModel user;

  const WalkerDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _WalkerDetailPageState createState() => _WalkerDetailPageState();
}

class _WalkerDetailPageState extends State<WalkerDetailPage> {
  late final PriceController _priceController;
  late Future<void> _fetchPricesFuture;
  Prices? _prices;
  DateTime _focusedDate = DateTime.now();

  AboutMeController? _aboutMeController;
  Future<void>? _fetchAboutMeFuture;
  String? _aboutMeText;

  String _selectedButton = 'info'; // Default to 'info'

  List<String>? _selectedSizes;
  List<String>? _selectedPetNumbers;
  List<String>? _selectedSkills;

  ImageProvider? _getProfileImage(String profilePicture) {
    try {
      if (profilePicture.isEmpty) {
        return null; // Placeholder icon if no profile picture
      } else if (_isNetworkUrl(profilePicture)) {
        return NetworkImage(profilePicture);
      } else {
        final file = File(profilePicture);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          print('File does not exist: $profilePicture');
          return null;
        }
      }
    } catch (e) {
      print('Error loading profile picture: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _priceController = PriceController();
    _fetchPricesFuture = _fetchPrices();
    _aboutMeController = AboutMeController();
    _fetchAboutMeFuture = _fetchAboutMe();
// Fetch pets data when initializing

    _fetchAvailabilityData(); // Fetch availability data when initializing
  }

  Future<void> _fetchPrices() async {
    try {
      final priceIds = await _fetchPriceIds();
      print('Price IDs: $priceIds'); // Debug print
      if (priceIds.isNotEmpty) {
        final priceId = priceIds.first;
        final prices = await _priceController.getPrices(
            widget.user.uid, widget.user.role, priceId);
        print('Fetched Prices: $prices'); // Debug print
        setState(() {
          _prices = Prices(
            dayCareEnabled: prices?.dayCareEnabled ?? false,
            houseSittingEnabled: prices?.houseSittingEnabled ?? false,
            walkingEnabled: prices?.walkingEnabled ?? false,
            dayCarePrice: prices?.dayCarePrice,
            houseSittingPrice: prices?.houseSittingPrice,
            walkingPrice: prices?.walkingPrice,
          );
        });
      } else {
        print('No price IDs found.'); // Debug print
      }
    } catch (e) {
      print('Error fetching prices: $e');
    }
  }

  Future<List<String>> _fetchPriceIds() async {
    try {
      final subCollection =
          widget.user.role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      final path =
          'users/${widget.user.uid}/$subCollection/${widget.user.uid}/price';
      final querySnapshot =
          await FirebaseFirestore.instance.collection(path).get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching price IDs: $e');
      return [];
    }
  }

  Future<void> _fetchAboutMe() async {
    try {
      final aboutMeId = await _aboutMeController?.getAboutMeId(
          widget.user.uid, widget.user.role);
      if (aboutMeId != null) {
        final aboutMeData = await _aboutMeController?.getAboutMeData(
            widget.user.uid, widget.user.role, aboutMeId);
        setState(() {
          _aboutMeText = aboutMeData?.aboutMe;
          _selectedSizes = aboutMeData?.selectedSizes;
          _selectedPetNumbers = aboutMeData?.selectedPetNumbers;
          _selectedSkills = aboutMeData?.selectedSkills;
        });
      } else {
        setState(() {
          _aboutMeText = 'No About Me data';
          _selectedSizes = [];
          _selectedPetNumbers = [];
          _selectedSkills = [];
        });
      }
    } catch (e) {
      print('Error fetching About Me data: $e');
    }
  }

  Future<String?> fetchProfilePicture(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        String? profilePictureUrl = userDoc.get('profilePicture') as String?;
        return profilePictureUrl;
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
    return null;
  }

  Future<void> _fetchAvailabilityData() async {
    try {
      final availabilityDoc = await FirebaseFirestore.instance
          .collection('availability')
          .doc(widget.user.uid)
          .get();

      if (availabilityDoc.exists) {
        final data = availabilityDoc.data();
        if (data != null) {
          final availability = data['availability'] as Map<String, dynamic>?;
          if (availability != null) {
            setState(() {});
          }
        }
      }
    } catch (e) {
      print('Error fetching availability data: $e');
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }

  @override
  Widget build(BuildContext context) {
    // Display a message if the user is not a walker

    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([_fetchPricesFuture, _fetchAboutMeFuture!]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Background header with overlapping profile section
                    Container(
                      color: Colors.white,
                      height: 200,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Header background
                          Container(
                            height: 170,
                            decoration: const BoxDecoration(
                              color: Color(0xFF967BB6),
                            ),
                            child: SafeArea(
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'PetPals',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Profile section overlapping the header
                          Positioned(
                            top:
                                150, // Adjust this value to control how much the profile overlaps the header
                            left: 16,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.user.firstName} ${widget.user.lastName}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: _getProfileImage(
                                        widget.user.profilePicture),
                                    backgroundColor:
                                        widget.user.profilePicture.isEmpty
                                            ? Colors.grey.shade200
                                            : null,
                                    radius: 50,
                                    child: widget.user.profilePicture.isEmpty
                                        ? const Icon(Icons.person,
                                            size: 40,
                                            color: Color.fromRGBO(
                                                158, 158, 158, 1))
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Info and Review buttons
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Info and Review buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedButton = 'info';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedButton == 'info'
                                        ? const Color(0xFFEFEAF8)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Info',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedButton = 'reviews';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        _selectedButton == 'reviews'
                                            ? const Color(0xFFEFEAF8)
                                            : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Reviews',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          // Info Section
                          Visibility(
                            visible: _selectedButton == 'info',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: _selectedButton == 'info',
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Pass all prices to the ServiceSection
                                          if (_prices !=
                                              null) // Ensure _prices is not null
                                            ServiceSection(
                                              dayCarePrice:
                                                  _prices!.dayCarePrice,
                                              houseSittingPrice:
                                                  _prices!.houseSittingPrice,
                                              walkingPrice:
                                                  _prices!.walkingPrice,
                                            )
                                          else
                                            const Center(
                                                child: Text(
                                                    'Prices not available.')), // Handle the case where prices are not available

                                          // Other widgets
                                        ],
                                      ),
                                    ),

                                    // Calendar Section
                                    const SizedBox(height: 16.0),
                                    _buildSectionTitle('Available Dates:'),
                                    const SizedBox(height: 6.0),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: const Color(0x0D967BB6),
                                      ),
                                      child:
                                          _buildCalendarSection(), // Use the custom calendar here
                                    ),

                                    const SizedBox(height: 10.0),
                                  ],
                                ),

                                // About Me Section
                                const SizedBox(height: 16.0),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context)
                                                .size
                                                .width -
                                            32), // Ensure it doesn't exceed screen width
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: const Color(0x0D967BB6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSectionTitle('About Me'),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          _aboutMeText ?? 'Loading...',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        _buildSectionTitle('Prefers:'),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          _selectedSizes?.isNotEmpty == true
                                              ? _selectedSizes!.join(', ')
                                              : 'No Preferences data',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        _buildSectionTitle(
                                            'Additional Skills:'),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          _selectedSkills?.isNotEmpty == true
                                              ? _selectedSkills!.join('\n')
                                              : 'No Additional Skills data',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Text(
                                          _selectedPetNumbers?.isNotEmpty ==
                                                  true
                                              ? 'Can take care of ${_selectedPetNumbers!.join(' or ')} pets at the same time.'
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        const Divider(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                          thickness: 0,
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),

                          // Reviews Section (Placeholder for actual reviews content)
                          Visibility(
                            visible: _selectedButton == 'reviews',
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFEAF8),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Text(
                                  'Reviews content will go here...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedButton == 'info',
                child: Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MyButton(
                      onTap: () {
                        if (_prices != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsPage(
                                prices: _prices!,
                                userId: widget.user.uid,
                                role: widget.user.role,
                              ),
                            ),
                          );
                        } else {
                          print(
                              'Prices are null, cannot navigate to BookingDetailsPage.'); // Debug print
                        }
                      },
                      text: 'Booking details',
                      color: const Color(0xFF967BB6),
                      textColor: Colors.white,
                      borderColor: const Color(0xFF967BB6),
                      borderWidth: 1.0,
                      width: 390,
                      height: 60,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCalendarSection() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(
              1, 150, 123, 182), // Light background color with some opacity
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        padding:
            const EdgeInsets.all(16.0), // Add some padding around the calendar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDate,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => false,
              onDaySelected: (selectedDay, focusedDay) {
                if (selectedDay != _focusedDate) {
                  setState(() {
                    _focusedDate = selectedDay;
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
                  return null;
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
