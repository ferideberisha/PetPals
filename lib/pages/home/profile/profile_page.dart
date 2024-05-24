import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/circle_avatar.dart'; // Import CircleAvatarWidget
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/auth/auth.dart';
import 'package:petpals/pages/home/profile/accountsettings/account_settings_page.dart';
import 'package:petpals/pages/home/profile/payment/my_payment_page.dart';
import 'package:petpals/pages/home/profile/pets/my_pets_page.dart';
import 'package:petpals/service/auth_service.dart';
import 'package:petpals/pages/home/profile/basicinfo/basic_info_page.dart'; // Import the BasicInfoPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _userName;
  File? _image;

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
  }

  void _getUserDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? 'User';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void signUserOut() {
    AuthService().signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
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
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 80, bottom: 90),
                    child: Text(
                      '$_userName',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
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
                                title: Text('Select Image Source'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _pickImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Camera'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _pickImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Gallery'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icons.person, // Use the user icon
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasicInfoPage()),
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
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPetsPage()),
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
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPaymentsPage()),
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
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSettingsPage()),
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
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  signUserOut();
                },
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(Icons.logout, color: Colors.red),
                    ),
                    SizedBox(width: 15),
                    const Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}
