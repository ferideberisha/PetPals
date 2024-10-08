import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/circle_avatar.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/pages/auth/auth.dart';
import 'package:petpals/pages/home/profile/aboutme/about_me_page.dart';
import 'package:petpals/pages/home/profile/business/my_business_page.dart';
import 'package:petpals/pages/home/profile/accountsettings/account_settings_page.dart';
import 'package:petpals/pages/home/profile/payment/my_payment_page.dart';
import 'package:petpals/pages/home/profile/pets/my_pets_page.dart';
import 'package:petpals/service/auth_service.dart';
import 'package:petpals/pages/home/profile/basicinfo/basic_info_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _userName = "Loading...";
String? _image; // Change from dynamic to String?

  bool isWalker = false;
  String? userId;
  String? role;

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
    _checkUserRole();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        role = userDoc.get('role') as String?;
        setState(() {});
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  void _getUserDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String firstName = userData['firstName'] ?? '';
      String lastName = userData['lastName'] ?? '';
      String profilePictureUrl = userData['profilePicture'] ?? '';

      setState(() {
        _userName = '$firstName $lastName';
        _image = profilePictureUrl.isNotEmpty ? profilePictureUrl : 'assets/default_profile_picture.png';
      });
    }
  }


  void _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        isWalker = userData['role'] == 'walker';
      });
    }
  }


Future<void> updateProfilePicture(String imageUrl) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'profilePicture': imageUrl});
        print('Profile picture updated successfully.');
        setState(() {
          _image = imageUrl; // Update the image URL
        });
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      rethrow;
    }
  }

 Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      final File image = File(pickedImage.path);
      final String fileName = '${DateTime.now().toIso8601String()}.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      try {
        // Upload the image to Firebase Storage
        await storageRef.putFile(image);

        // Get the download URL
        final String downloadUrl = await storageRef.getDownloadURL();

        // Save the download URL to Firestore
        await updateProfilePicture(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

Widget _buildProfileImage(String imageUrl) {
  return Image.network(imageUrl); // Fetches image from the network
}


  void signUserOut() {
    AuthService().signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()));
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Text(
                    _userName.isNotEmpty ? _userName : 'Loading...',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 110),
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatarWidget(
                          pickImage: _pickImage,
                          image: _image != null
                              ? (_image!.startsWith('assets/') ? AssetImage(_image!) : NetworkImage(_image!) as ImageProvider)
                              : null,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Select Image Source'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Camera'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _pickImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Gallery'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icons.person,
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFEFEAF8),
                              radius: 16,
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // Basic Info button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BasicInfoPage(),
                  ),
                );
              },
              child: const Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.info, color: Colors.black),
                  SizedBox(width: 15),
                  Text(
                    'Basic info',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: SizedBox()),
                  Icon(Icons.arrow_forward_ios, color: Colors.black),
                  SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isWalker) ...[
              TextButton(
                onPressed: () {
                  if (userId != null && role != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutMePage(
                          userId: userId!,
                          role: role!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to load user information.'),
                      ),
                    );
                  }
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.person, color: Colors.black),
                    SizedBox(width: 15),
                    Text(
                      'About me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyBusinessPage()),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.business_center_sharp, color: Colors.black),
                    SizedBox(width: 15),
                    Text(
                      'My business',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
            // Pets Section (only for owners)
            if (!isWalker)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPetsPage(
                        userId: userId!,
                        role: role!,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.pets, color: Colors.black),
                    SizedBox(width: 15),
                    Text(
                      'My pets',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            // Payments Section (only for owners)
            if (!isWalker)
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPaymentsPage(
                            userId: userId!,
                            role: role!,
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.payment_rounded, color: Colors.black),
                        SizedBox(width: 15),
                        Text(
                          'Sending payments',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(child: SizedBox()),
                        Icon(Icons.arrow_forward_ios, color: Colors.black),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Adds space after the payments section
                ],
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSettingsPage()),
                );
              },
              child: const Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.settings, color: Colors.black),
                  SizedBox(width: 15),
                  Text(
                    'Account settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: SizedBox()),
                  Icon(Icons.arrow_forward_ios, color: Colors.black),
                  SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                signUserOut();
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: const Icon(Icons.logout, color: Colors.red),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
  );
}
}