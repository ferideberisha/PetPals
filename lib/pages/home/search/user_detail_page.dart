import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/aboutme_controller.dart';
import 'package:petpals/controllers/price_controller.dart';
import 'package:petpals/models/userModel.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  double? _walkingPrice;
  late final PriceController _priceController;
  late Future<void> _fetchPricesFuture;

  // Add state variables for About Me section
  AboutMeController? _aboutMeController;
  Future<void>? _fetchAboutMeFuture;
  String? _aboutMeText;

  // State variables for button selection
  String _selectedButton = '';

  // State variables for About Me section
  List<String>? _selectedSizes;
  List<String>? _selectedPetNumbers;
  List<String>? _selectedSkills;

  @override
  void initState() {
    super.initState();
    _priceController = PriceController();
    _fetchPricesFuture = _fetchPrices();

    _aboutMeController = AboutMeController(); // Initialize AboutMeController
    _fetchAboutMeFuture = _fetchAboutMe();
  }

  Future<void> _fetchPrices() async {
    try {
      final priceIds = await _fetchPriceIds();
      if (priceIds.isNotEmpty) {
        final priceId = priceIds.first;
        final prices = await _priceController.getPrices(widget.user.uid, widget.user.role, priceId);
        setState(() {
          _walkingPrice = prices?.walkingPrice;
        });
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

        return SingleChildScrollView(
          child: Column(
            children: [
              // Background header
              Container(
                height: 170,
                decoration: const BoxDecoration(
                  color: Color(0xFF967BB6),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      // Back button
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

                      // Heart icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.white,
                          onPressed: () {
                            // Handle favorite action
                          },
                        ),
                      ),

                      // Title
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
  // Profile section
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                        backgroundImage: NetworkImage(
                          widget.user.profilePicture.isNotEmpty
                              ? widget.user.profilePicture
                              : 'https://via.placeholder.com/150',
                        ),
                        radius: 50,
                      ),
                    ),
                  ],
                ),
              ),
              // Info and Review buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedButton = 'info';
                          });
                          // Handle Info button action
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
                          // Handle Review button action
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
              ),

              // Services Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEAF8),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_walk,
                        color: Colors.green,
                        size: 28.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Walking',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${_walkingPrice?.toStringAsFixed(0)} EUR',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  'per hour',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            

              // About Me section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Color.fromARGB(111, 186, 186, 186),
                      thickness: 0.5,
                      height: 0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About Me',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
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
                            color: Colors.black38,
                            thickness: 0.5,
                            height: 20,
                          ),
                          const SizedBox(height: 25),
                          MyButton(
                            onTap: () {
                              // Handle button action here
                            },
                            text: 'Booking details',
                            color: const Color(0xFF967BB6),
                            textColor: Colors.white,
                            borderColor: const Color(0xFF967BB6),
                            borderWidth: 1.0,
                            width: 390,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
