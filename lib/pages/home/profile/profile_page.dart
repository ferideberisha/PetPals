import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/circle_avatar.dart'; // Import CircleAvatarWidget
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/pages/auth/auth.dart';
import 'package:petpals/pages/home/business/my_bussines_page.dart';
import 'package:petpals/pages/home/profile/aboutme/about_me_page.dart';
import 'package:petpals/pages/home/profile/accountsettings/account_settings_page.dart';
import 'package:petpals/pages/home/profile/payment/my_payment_page.dart';
import 'package:petpals/pages/home/profile/pets/my_pets_page.dart';
import 'package:petpals/service/auth_service.dart';
import 'package:petpals/pages/home/profile/basicinfo/basic_info_page.dart'; // Import the BasicInfoPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _userName = "Loading..."; // Initialize _userName with "Loading..."
  dynamic _image; // Can be a File or a String URL
  bool isWalker = false; // Variable to store if the user is a walker

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
    _checkUserRole(); // Check user role when the widget initializes
  }

  void _getUserDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      String firstName = userData['firstName'] ?? '';
      String lastName = userData['lastName'] ?? '';
      String profilePictureUrl = userData['profilePicture'] ?? '';
      setState(() {
        _userName = '$firstName $lastName';
        if (profilePictureUrl.isNotEmpty) {
          _image = profilePictureUrl;
        }
      });
    }
  }

  // Function to check if the user is a walker
  void _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      setState(() {
        isWalker = userData['userType'] == 'walker'; // Check if user role is 'walker'
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      final File image = File(pickedImage.path);

      try {
        final imageUrl = await uploadImageToStorage(image);
        await updateProfilePicture(imageUrl);
        setState(() {
          _image = image;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref('Users/Images/Profile/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw e;
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
      }
    } catch (e) {
      throw e;
    }
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
                    padding: const EdgeInsets.only(bottom: 75),
                    child: Text(
                      _userName.isNotEmpty ? _userName : 'Loading...',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 142),
                  Row(
                    children: [
                      CircleAvatarWidget(
                        pickImage: _pickImage,
                        image: _image,
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
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicInfoPage()),
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
                 if (isWalker)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutMePage()),
                  );
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
                    MaterialPageRoute(builder: (context) => const MyPetsPage()),
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
                        fontSize
: 16,
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
                 if (isWalker)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyBusinessPage()),
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
                        fontSize
: 16,
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
                    MaterialPageRoute(builder: (context) => const MyPaymentsPage()),
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
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
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
