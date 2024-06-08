import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final TextEditingController _aboutmeController = TextEditingController();
  final List<String> _selectedSizes = [];
  final List<String> _selectedPetNumbers = [];
  final List<String> _selectedSkills = [];
  bool _isAboutMeError = false;
  bool _isSizeError = false;
  bool _isPetNumberError = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _aboutmeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Reset error flags before validating the form
    setState(() {
      _isAboutMeError = false;
      _isSizeError = false;
      _isPetNumberError = false;
      // Add more error flags if needed for other fields
    });

    // Check if description is filled
    if (_aboutmeController.text.isEmpty) {
      setState(() {
        _isAboutMeError = true; // Set flag to display description error
      });
    }

    // Check if size is selected
    if (_selectedSizes.isEmpty) {
      setState(() {
        _isSizeError = true; // Set flag to display size error
      });
    }

    // Check if pet number is selected
    if (_selectedPetNumbers.isEmpty) {
      setState(() {
        _isPetNumberError = true; // Set flag to display pet number error
      });
    }

    // Check other fields if needed

    // If any error flag is true, return without submitting the form
    if (_isAboutMeError || _isSizeError || _isPetNumberError /* Add more conditions if needed */) {
      // You can show a snackbar or set an error message for each field if needed
      return;
    }

    // If all fields are filled, you can proceed with form submission logic here
    // For example, you can save the form data, navigate to another screen, or perform any other action
  }

  void _toggleSize(String size) {
    setState(() {
      if (_selectedSizes.contains(size)) {
        _selectedSizes.remove(size);
      } else {
        _selectedSizes.add(size);
      }
      _isSizeError = false; // Clear the error flag
    });
  }

  void _togglePetNumber(String number) {
    setState(() {
      if (_selectedPetNumbers.contains(number)) {
        _selectedPetNumbers.remove(number);
      } else {
        _selectedPetNumbers.add(number);
      }
      _isPetNumberError = false; // Clear the error flag
    });
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _showSizeSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSizeTile('1-5 kg', setState),
                _buildSizeTile('5-10 kg', setState),
                _buildSizeTile('10-15 kg', setState),
                _buildSizeTile('15-20 kg', setState),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  ListTile _buildSizeTile(String size, StateSetter setState,) {
    return ListTile(
      title: Text(size),
      trailing: _selectedSizes.contains(size)
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() {
          _toggleSize(size);
        });
      },
        hoverColor: Colors.transparent, // Remove hover color
    focusColor: Colors.transparent, // Remove focus color
    splashColor: Colors.transparent, // Remove splash color
    
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About me',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shadowColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              // Call _submitForm only when the Save button is pressed
              _submitForm();
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  Colors.transparent), // Remove hover effect
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF967BB6), // Set the text color to the desired color
                fontWeight: FontWeight.bold,
                fontSize: 18, // Optional: make the text bold
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: _isAboutMeError
                              ? Colors.red
                              : const Color(0xFFCAADEE),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _aboutmeController,
                          maxLines: null, // Allows the text field to expand vertically
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'Write about your pet care experience',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none, // Remove default border
                            errorBorder: InputBorder.none, // Remove error border
                            focusedErrorBorder: InputBorder.none, // Remove focused error border
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isAboutMeError)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 10.0),
                      child: Text(
                        'Please describe your pet care experience',
                        style: TextStyle(
                          color: Color.fromARGB(255, 175, 29, 29),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Prefers',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Size (kg)', style: TextStyle(color: Colors.grey[700])),
                    InkWell(
                      onTap: _showSizeSelectionSheet,
                      child: const Text(
                        '+Add',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isSizeError)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 10.0),
                      child: Text(
                        'Required field',
                        style: TextStyle(
                          color: Color.fromARGB(255, 175, 29, 29),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: _selectedSizes
                      .map((size) => Chip(
                            label: Text(size),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Other information',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: const Color(0xFFCAADEE)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('How many pets can you look after at the same time',
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 10), // Ensure this is consistent on both sides
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          _togglePetNumber('1');
                        },
                        text: '1',
                        color: _selectedPetNumbers.contains('1')
                            ? const Color(0xFFCAADEE)
                            : Colors.white,
                        textColor: Colors.black,
                        borderColor: _isPetNumberError ? Colors.red : const Color(0xFFCAADEE),
                        borderWidth: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          _togglePetNumber('3+');
                        },
                        text: '3+',
                        color: _selectedPetNumbers.contains('3+')
                            ? const Color(0xFFCAADEE)
                            : Colors.white,
                        textColor: Colors.black,
                        borderColor: _isPetNumberError ? Colors.red : const Color(0xFFCAADEE),
                        borderWidth: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          _togglePetNumber('2');
                        },
                        text: '2',
                        color: _selectedPetNumbers.contains('2')
                            ? const Color(0xFFCAADEE)
                            : Colors.white,
                        textColor: Colors.black,
                        borderColor: _isPetNumberError ? Colors.red : const Color(0xFFCAADEE),
                        borderWidth: 1,
                      ),
                    ),
                    const SizedBox(width: 10), // Ensure this is consistent on both sides
                  ],
                ),

                 if (_isPetNumberError)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 10.0),
                      child: Text(
                        'Required field',
                        style: TextStyle(
                          color: Color.fromARGB(255, 175, 29, 29),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Additional skills',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                  Wrap(
                  spacing: 8.0,
                  children: [
                    MyButton(
                      onTap: () {
                        _toggleSkill('Senior dog experience');
                      },
                      text: 'Senior dog experience',
                      color: _selectedSkills.contains('Senior dog experience')
                          ? const Color(0xFFCAADEE)
                          : Colors.white,
                      textColor: Colors.black,
                      borderColor: const Color(0xFFCAADEE),
                      borderWidth: 1,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      onTap: () {
                        _toggleSkill('Special needs dog experience');
                      },
                      text: 'Special needs dog experience',
                      color: _selectedSkills.contains('Special needs dog experience')
                          ? const Color(0xFFCAADEE)
                          : Colors.white,
                      textColor: Colors.black,
                      borderColor: const Color(0xFFCAADEE),
                      borderWidth: 1,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      onTap: () {
                        _toggleSkill('First AID/CPR');
                      },
                      text: 'First AID/CPR',
                      color: _selectedSkills.contains('First AID/CPR')
                          ? const Color(0xFFCAADEE)
                          : Colors.white,
                      textColor: Colors.black,
                      borderColor: const Color(0xFFCAADEE),
                      borderWidth: 1,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      onTap: () {
                        _toggleSkill('Dangerous dog breeds care');
                      },
                      text: 'Dangerous dog breeds care',
                      color: _selectedSkills.contains('Dangerous dog breeds care')
                          ? const Color(0xFFCAADEE)
                          : Colors.white,
                      textColor: Colors.black,
                      borderColor: const Color(0xFFCAADEE),
                      borderWidth: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
