import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/aboutme_controller.dart';
import 'package:petpals/models/aboutmeModel.dart';

class AboutMePage extends StatefulWidget {
      final String userId;
 final String role;
  const AboutMePage({super.key, required this.userId, required this.role});

  @override
  // ignore: library_private_types_in_public_api
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final AboutMeController _aboutMeController = AboutMeController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _otherinfoController = TextEditingController();
  final List<String> _selectedSizes = [];
  final List<String> _selectedPetNumbers = [];
  final List<String> _selectedSkills = [];
  bool _isAboutMeError = false;
  bool _isSizeError = false;
  bool _isPetNumberError = false;
  String? _aboutMeId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchAboutMeData(); // Fetch data when the page is initialized
  }

  Future<void> _fetchAboutMeData() async {
    try {
      // Fetch existing aboutMeId or create a new one if it doesn't exist
      _aboutMeId = await _aboutMeController.getAboutMeId(widget.userId, widget.role);

      if (_aboutMeId != null) {
        AboutMeFormData? aboutMeData = await _aboutMeController.getAboutMeData(widget.userId, widget.role, _aboutMeId!);

        // Populate the fields with fetched data
        if (aboutMeData != null) {
          setState(() {
            _aboutController.text = aboutMeData.aboutMe;
            _otherinfoController.text = aboutMeData.otherInfo;
            _selectedSizes.addAll(aboutMeData.selectedSizes);
            _selectedPetNumbers.addAll(aboutMeData.selectedPetNumbers);
            _selectedSkills.addAll(aboutMeData.selectedSkills);
          });
        }
      }
    } catch (e) {
      print('Error fetching About Me data: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load About Me information.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void _submitForm() async {
    // ... (keep the existing form validation logic)

    if (_isAboutMeError || _isSizeError || _isPetNumberError) {
      return;
    }

    try {
      AboutMeFormData aboutMeData = AboutMeFormData(
        aboutMe: _aboutController.text,
        otherInfo: _otherinfoController.text,
        selectedSizes: _selectedSizes,
        selectedPetNumbers: _selectedPetNumbers,
        selectedSkills: _selectedSkills,
      );

      if (_aboutMeId == null) {
        _aboutMeId = await _aboutMeController.createAboutMeData(aboutMeData, widget.userId, widget.role);
      } else {
        await _aboutMeController.updateAboutMeData(aboutMeData, widget.userId, widget.role, _aboutMeId!);
      }

      Navigator.pop(context, aboutMeData);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('About Me information saved successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print('Error saving About Me information: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save About Me information.'),
        duration: Duration(seconds: 2),
      ));
    }
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
                          controller: _aboutController,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      controller: _otherinfoController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
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