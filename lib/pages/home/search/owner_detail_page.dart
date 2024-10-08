import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/models/petModel.dart';

class OwnerDetailPage extends StatefulWidget {
  final UserModel user;

  const OwnerDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _OwnerDetailPageState createState() => _OwnerDetailPageState();
}

class _OwnerDetailPageState extends State<OwnerDetailPage> {
  @override
  void initState() {
    super.initState();
    _fetchPetsFuture = _fetchPets(); // Fetch pets data when initializing
  }

  Future<List<Pet>> _fetchPets() async {
    try {
      final petsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection('ownerInfo')
          .doc(widget.user.uid)
          .collection('pets');
      final querySnapshot = await petsCollection.get();
      return querySnapshot.docs
          .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching pets: $e');
      return [];
    }
  }

  late Future<List<Pet>> _fetchPetsFuture;

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

  ImageProvider? _getPetProfileImge(String imagePath) {
    try {
      if (imagePath.isEmpty) {
        return null; // Placeholder icon if no profile picture
      } else if (_isNetworkUrl(imagePath)) {
        return NetworkImage(imagePath);
      } else {
        final file = File(imagePath);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          print('File does not exist: $imagePath');
          return null;
        }
      }
    } catch (e) {
      print('Error loading profile picture: $e');
      return null;
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
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
                Positioned(
                  top: 150,
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
                          backgroundImage: _getProfileImage(widget.user.profilePicture),
                          backgroundColor: widget.user.profilePicture.isEmpty ? Colors.grey.shade200 : null,
                          radius: 50,
                          child: widget.user.profilePicture.isEmpty
                              ? const Icon(Icons.person, size: 40, color: Color.fromRGBO(158, 158, 158, 1))
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 58),
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: _fetchPetsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final pets = snapshot.data ?? [];

                if (pets.isEmpty) {
                  return const Center(child: Text('No pets found.'));
                }

                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Card(
  elevation: 0, // Remove shadow
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin as needed
  color: const Color(0x0D967BB6), // Set background color
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Set border radius
  ),
  child: Padding(
    padding: const EdgeInsets.all(13.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Pet Image
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ClipOval(
            child: SizedBox(
              height: 70,
              width: 70,
              child: CircleAvatar(
                backgroundImage: _getPetProfileImge(pet.imagePath),
                backgroundColor: pet.imagePath.isEmpty ? Colors.grey.shade200 : null,
                radius: 50,
                child: pet.imagePath.isEmpty
                    ? const Icon(Icons.pets, size: 40, color: Color.fromRGBO(158, 158, 158, 1))
                    : null,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Name
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              // Gender and Size
              Text(
                '${pet.gender} - Size: ${pet.sizeRange}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(117, 117, 117, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
