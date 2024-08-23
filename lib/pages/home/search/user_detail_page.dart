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

class UserDetailPage extends StatefulWidget {
  final UserModel user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late final PriceController _priceController;
  late Future<void> _fetchPricesFuture;
  Prices? _prices; // Add this field
  DateTime _selectedDate = DateTime.now();

  AboutMeController? _aboutMeController;
  Future<void>? _fetchAboutMeFuture;
  String? _aboutMeText;

  String _selectedButton = 'info'; // Default to 'info'

  List<String>? _selectedSizes;
  List<String>? _selectedPetNumbers;
  List<String>? _selectedSkills;
  String? _profilePictureUrl;
  
  
  @override
  void initState() {
    super.initState();
    _priceController = PriceController();
    _fetchPricesFuture = _fetchPrices();

    _aboutMeController = AboutMeController();
    _fetchAboutMeFuture = _fetchAboutMe();
    _fetchProfilePicture();
  }

  Future<void> _fetchProfilePicture() async {
    _profilePictureUrl = await fetchProfilePicture(widget.user.uid);
    setState(() {});
  }

Future<void> _fetchPrices() async {
  try {
    final priceIds = await _fetchPriceIds();
    print('Price IDs: $priceIds'); // Debug print
    if (priceIds.isNotEmpty) {
      final priceId = priceIds.first;
      final prices = await _priceController.getPrices(widget.user.uid, widget.user.role, priceId);
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
      final subCollection = widget.user.role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      final path = 'users/${widget.user.uid}/$subCollection/${widget.user.uid}/price';
      final querySnapshot = await FirebaseFirestore.instance.collection(path).get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching price IDs: $e');
      return [];
    }
  }

  Future<void> _fetchAboutMe() async {
    try {
      final aboutMeId = await _aboutMeController?.getAboutMeId(widget.user.uid, widget.user.role);
      if (aboutMeId != null) {
        final aboutMeData = await _aboutMeController?.getAboutMeData(widget.user.uid, widget.user.role, aboutMeId);
        setState(() {
          _aboutMeText = aboutMeData?.aboutMe;
          _selectedSizes = aboutMeData?.selectedSizes;
          _selectedPetNumbers = aboutMeData?.selectedPetNumbers;
          _selectedSkills = aboutMeData?.selectedSkills;
        });
      } else {
        setState(() {
          _aboutMeText = 'No About Me data available.';
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

  bool _isNetworkUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }



  @override
Widget build(BuildContext context) {
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
                          top: 150,  // Adjust this value to control how much the profile overlaps the header
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
                                  radius: 50,
                                  backgroundImage: _profilePictureUrl != null
                                      ? _isNetworkUrl(_profilePictureUrl!)
                                          ? NetworkImage(_profilePictureUrl!)
                                          : FileImage(File(_profilePictureUrl!)) as ImageProvider
                                      : const AssetImage('assets/images/placeholder.png'),
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
                                  backgroundColor: _selectedButton == 'info' ? const Color(0xFFEFEAF8) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
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
                                  backgroundColor: _selectedButton == 'reviews' ? const Color(0xFFEFEAF8) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Pass all prices to the ServiceSection
      if (_prices != null) // Ensure _prices is not null
        ServiceSection(
          dayCarePrice: _prices!.dayCarePrice,
          houseSittingPrice: _prices!.houseSittingPrice,
          walkingPrice: _prices!.walkingPrice,
        )
      else
        Center(child: Text('Prices not available.')), // Handle the case where prices are not available
      
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
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Color(0x0D967BB6),
                                    ),
                                    child: TableCalendar(
                                      focusedDay: _selectedDate,
                                      firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
                                      lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
                                      selectedDayPredicate: (day) => false, // No day should be selected
                                    ),
                                  ),

                                  const SizedBox(height: 10.0),
                                ],
                              ),

                              // About Me Section
                              const SizedBox(height: 16.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32), // Ensure it doesn't exceed screen width
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Color(0x0D967BB6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            : 'Loading...',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      _buildSectionTitle('Additional Skills:'),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        _selectedSkills?.isNotEmpty == true
                                            ? _selectedSkills!.join(', ')
                                            : 'Loading...',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Text(
                                        _selectedPetNumbers?.isNotEmpty == true
                                            ? 'Can take care of ${_selectedPetNumbers!.join(' or ')} pets at the same time.'
                                            : 'Loading...',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Divider(
                                        color: Color.fromRGBO(238, 238, 238, 1),
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
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
      prices: _prices!, userId: widget.user.uid, role: widget.user.role,
    ),
  ),
);

} else {
  print('Prices are null, cannot navigate to BookingDetailsPage.'); // Debug print
}

      },
      text: 'Booking details',
      color: const Color(0xFF967BB6),
      textColor: Colors.white,
      borderColor: const Color(0xFF967BB6),
      borderWidth: 1.0,
      height: 60,
    ),
  ),
),

          ),  ],
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
}