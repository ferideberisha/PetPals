import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/my_phone_number.dart';
import 'package:petpals/components/my_textfield.dart'; // Import MyTextField
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'; // Import the new date picker

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _initializeBirthday();
  }

  void _loadUserInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _firstNameController.text = user.displayName?.split(' ').first ?? '';
        _lastNameController.text = user.displayName?.split(' ').last ?? '';
        _emailController.text = user.email ?? '';
      });
    }
  }

  void _initializeBirthday() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _birthdayController.text = formattedDate;
  }

  void _selectBirthday(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        setState(() {
          _birthdayController.text = DateFormat('yyyy-MM-dd').format(date);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Info',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              MyTextField(
                controller: _firstNameController,
                hintText: 'First Name',
                obscureText: false,
                fillColor: Colors.white,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
                obscureText: false,
                fillColor: Colors.white,
              ),
              const SizedBox(height: 10),
              MyPhoneNumberButton(
                hintText: 'Phone Number',
                controller: _phoneNumberController,
                enabled:
                    true, // Set to false when the phone number is confirmed
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
                fillColor: Colors.white,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _birthdayController,
                hintText: 'Birthday',
                obscureText: false,
                fillColor: Colors.white,
                onTap: () => _selectBirthday(context),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _addressController,
                hintText: 'Address',
                obscureText: false,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes saved')),
                    );
                  }
                },
                text: 'Save Changes',
                color: const Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: const Color(0xFF967BB6),
                borderWidth: 1.0,
              ),
              MyButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Deletion"),
                        content: const Text(
                            "Are you sure you want to delete your account? This action cannot be undone."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add code here to delete the account
                              Navigator.of(context).pop();
                            },
                            child: const Text("Delete",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                text: 'Delete My Account',
                color: Colors.transparent, // Transparent background
                textColor: Colors.red, // Red text color
                borderColor: Colors.transparent, // Transparent border
                borderWidth: 0, // No border width
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}
