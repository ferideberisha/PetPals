import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/auth/auth.dart';
import 'package:petpals/service/auth_service.dart';

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
    print("User: $user");
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? 'User';
      });
    } else {
      print("User is null");
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[200], // Light grey background color
                            foregroundColor: Colors.grey, // Grey color for the icon or image
                            radius: 60,
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null
                            
                                ? Icon(Icons.person, size: 80)
                                : null,
                          ),
                          GestureDetector(
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 202, 173, 238), // Background color for the edit icon
                                shape: BoxShape.circle, // Shape of the container
                                border: Border.all(color: Colors.white, width: 3.0), // White border
                              ),
                              padding: EdgeInsets.all(8.0), // Padding for the edit icon
                              child: Icon(Icons.edit),
                            ),
                          ),

                        ],
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
                  // Add functionality for the clickable item here
                  print('Basic info button tapped!');
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10), // Space before the info icon
                    Icon(Icons.info, color: Colors.black),
                    SizedBox(width: 15), // Space between icon and text
                    Text(
                      'Basic info',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // Space between text and arrow icon
                    Expanded(child: SizedBox()), // This expands and creates space between text and arrow icon
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10), // Space after the arrow icon
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add functionality for the clickable item here
                  print('My Pets button tapped!');
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10), // Space before the paw icon
                    Icon(Icons.pets, color: Colors.black),
                    SizedBox(width: 15), // Space between icon and text
                    Text(
                      'My pets',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // Space between text and arrow icon
                    Expanded(child: SizedBox()), // This expands and creates space between text and arrow icon
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10), // Space after the arrow icon
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add functionality for the clickable item here
                  print('Sending Payments button tapped!');
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10), // Space before the card icon
                    Icon(Icons.payment_rounded, color: Colors.black),
                    SizedBox(width: 15), // Space between icon and text
                    Text(
                      'Sending payments',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // Space between text and arrow icon
                    Expanded(child: SizedBox()), // This expands and creates space between text and arrow icon
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10), // Space after the arrow icon
                  ],
                ),
              ),
               SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add functionality for the clickable item here
                  print('Account settings button tapped!');
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10), // Space before the card icon
                    Icon(Icons.settings, color: Colors.black),
                    SizedBox(width: 15), // Space between icon and text
                    Text(
                      'Account settings',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // Space between text and arrow icon
                    Expanded(child: SizedBox()), // This expands and creates space between text and arrow icon
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10), // Space after the arrow icon
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add functionality for the clickable item here
                  signUserOut(); // This calls the signOut function when the logout button is tapped
                },
                child: Row(
                  children: [
                    SizedBox(width: 10), // Space before the logout icon
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi), // Rotate 180 degrees horizontally
                      child: Icon(Icons.logout, color: Colors.red),
                    ),
                    SizedBox(width: 15), // Space between icon and text
                    const Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8), // Space between text and arrow icon
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

