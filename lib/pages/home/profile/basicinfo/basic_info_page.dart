import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:petpals/pages/auth/auth.dart';

const List<String> citiesOfKosovo = [
  'Prishtinë',
  'Prizren',
  'Pejë',
  'Gjakovë',
  'Mitrovicë',
  'Ferizaj',
  'Gjilan',
  'Vushtrri',
  'Podujevë',
];

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({super.key});

  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Add phone number controller
String? _selectedCity;


@override
void initState() {
  super.initState();
  _loadUserInfo();
}

void _loadUserInfo() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      setState(() {
        _firstNameController.text = userDoc['firstName'] ?? '';
        _lastNameController.text = userDoc['lastName'] ?? '';
        _emailController.text = user.email ?? '';
        _birthdayController.text = userDoc['birthday'] ?? ''; 
        _phoneController.text = userDoc['phoneNumber'] ?? '';

        // Safely load selected city
        if (userDoc['address'] != null && userDoc['address'] is String && citiesOfKosovo.contains(userDoc['address'])) {
          _selectedCity = userDoc['address'];
        }
      });
    }
  }
}


Future<void> _updateUserInfo() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    if (_isUnderage(_birthdayController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be at least 18 years old to use this app.')),
      );
      return;
    }

    try {
      final Map<String, dynamic> updateData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'birthday': _birthdayController.text,
         'address': _selectedCity, // Save the selected city
        'phoneNumber': _phoneController.text, // Update phone number if needed
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving changes')),
      );
    }
  }
}

bool _isUnderage(String birthday) {
  DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthday);
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;

  if (birthDate.month > today.month ||
      (birthDate.month == today.month && birthDate.day > today.day)) {
    age--;
  }

  return age < 18;
}


Future<void> _deleteUser() async {
  String? password = await _showPasswordDialog();

  if (password == null || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password is required for re-authentication')),
    );
    return;
  }

  await _reauthenticateUser(password);

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      final subCollectionRefs = ['walkerInfo', 'ownerInfo'];
      for (String subCollection in subCollectionRefs) {
        final subCollectionSnap = await userDoc.collection(subCollection).get();
        for (var doc in subCollectionSnap.docs) {
          await doc.reference.delete();
        }
      }

      await userDoc.delete();
      await user.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Auth error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting account')),
      );
    }
  }
}Future<void> _reauthenticateUser(String password) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      print('Re-authentication successful.');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during re-authentication: $e')),
      );
    }
  }
}

Future<String?> _showPasswordDialog() async {
  TextEditingController passwordController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Re-authenticate'),
      content: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Enter your password'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(passwordController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
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


  // void _navigateToAddPhoneNumberPage() async {
  //   final result = await Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => AddPhoneNumberPage()),
  //   );
  //   if (result != null && result is String) {
  //     setState(() {
  //     //  _phoneController.text = result; // Update phone number with the result
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Info', style: TextStyle(fontWeight: FontWeight.bold)),
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
  controller: _phoneController,
  hintText: 'Phone number',
  obscureText: false,
  fillColor: Colors.white,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    TextInputFormatter.withFunction((oldValue, newValue) {
      String newText = newValue.text;

      // Limit to exactly 11 digits
      if (newText.length > 11) {
        newText = newText.substring(0, 11);
      }

      return newValue.copyWith(text: newText);
    }),
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 11) {
      return 'Phone number must be exactly 11 digits';
    }
    return null;
  },
),

              const SizedBox(height: 10),
        DropdownButtonFormField<String>(
  value: _selectedCity,
  items: citiesOfKosovo.map((String city) {
    return DropdownMenuItem<String>(
      value: city,
      child: Text(city),
    );
  }).toList(),
  onChanged: (newValue) {
    setState(() {
      _selectedCity = newValue;
    });
  },
  decoration: InputDecoration(
    fillColor: Colors.white,
    filled: true,
    hintText: 'Select City',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select your city';
    }
    return null;
  },
),

              const SizedBox(height: 20),
              MyButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _updateUserInfo(); // Call the method to update user info
                  }
                },
                text: 'Save Changes',
                color: const Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: const Color(0xFF967BB6),
                borderWidth: 1.0,
                width: 390,
                height: 60,
              ),
              SizedBox(height: 10),
              // MyButton(
              //   onTap: _navigateToAddPhoneNumberPage,
              //   text: 'Add Phone Number',
              //   color: const Color(0xffffffff),
              //   textColor: Color(0xFF967BB6),
              //   borderColor: const Color(0xFF967BB6),
              //   borderWidth: 1.0,
              //   width: 390,
              //   height: 60,
              // ),
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
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _deleteUser(); // Call the delete user method
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
                color: Colors.transparent,
                textColor: Colors.red,
                borderColor: Colors.transparent,
                borderWidth: 0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}
