import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/circle_avatar.dart'; // Import CircleAvatarWidget
import 'package:petpals/components/my_textfield.dart'; // Import your custom text field

class AddPetPage extends StatefulWidget {
  @override
  _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  String? _selectedSizeRange;
  bool _isMicrochipped = false;
  bool _isFriendlyWithChildren = false;
  bool _isSpayedOrNeutered = false;
  bool _isFriendlyWithDogs = false;
  bool _isHouseTrained = false;
  bool _isFriendlyWithCats = false;


  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatarWidget(
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
                icon: Icons.pets, // Use the paw icon
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name, age',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                MyTextField(
                  controller: _nameController,
                  hintText: 'Enter your pet\'s name',
                  obscureText: false,
                  fillColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pet\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _ageController,
                  hintText: 'Age',
                  obscureText: false,
                  fillColor: Colors.white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pet\'s age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Text('Gender', style: TextStyle(color: Colors.grey[700])),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            _isMaleSelected = true;
                            _isFemaleSelected = false;
                          });
                        },
                        text: 'Male',
                        color: _isMaleSelected ? Color(0xFFCAADEE) : Colors.white,
                        textColor: Colors.black,
                        borderColor: Color(0xFFCAADEE),
                        borderWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            _isMaleSelected = false;
                            _isFemaleSelected = true;
                          });
                        },
                        text: 'Female',
                        color: _isFemaleSelected ? Color(0xFFCAADEE) : Colors.white,
                        textColor: Colors.black,
                        borderColor: Color(0xFFCAADEE),
                        borderWidth: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Size (kg)', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: MyButton(
                    onTap: () {
                      setState(() {
                        _selectedSizeRange = '1-5';
                      });
                    },
                    text: '1-5',
                    color: _selectedSizeRange == '1-5' ? Color(0xFFCAADEE) : Colors.white,
                    textColor: Colors.black,
                    borderColor: Color(0xFFCAADEE),
                    borderWidth: 2,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: MyButton(
                    onTap: () {
                      setState(() {
                        _selectedSizeRange = '5-10';
                      });
                    },
                    text: '5-10',
                    color: _selectedSizeRange == '5-10' ? Color(0xFFCAADEE) : Colors.white,
                    textColor: Colors.black,
                    borderColor: Color(0xFFCAADEE),
                    borderWidth: 2,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: MyButton(
                    onTap: () {
                      setState(() {
                        _selectedSizeRange = '10-15';
                      });
                    },
                    text: '10-15',
                    color: _selectedSizeRange == '10-15' ? Color(0xFFCAADEE) : Colors.white,
                    textColor: Colors.black,
                    borderColor: Color(0xFFCAADEE),
                    borderWidth: 2,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: MyButton(
                    onTap: () {
                      setState(() {
                        _selectedSizeRange = '15-20';
                      });
                    },
                    text: '15-20',
                    color: _selectedSizeRange == '15-20' ? Color(0xFFCAADEE) : Colors.white,
                    textColor: Colors.black,
                    borderColor: Color(0xFFCAADEE),
                    borderWidth: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text('About the pet',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                )),
            SizedBox(height: 15),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xFFCAADEE)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  maxLines: null, // Allows the text field to expand vertically
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Describe the nature of your pet and its habits',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey), // Lighter color for hintText
                    border: InputBorder.none, // Remove default border
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            SwitchListTile(
              title: Text(
                'Microchipped',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isMicrochipped,
              onChanged: (bool value) {
                setState(() {
                  _isMicrochipped = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF967BB6), // Set active track color
            ),
            SwitchListTile(
              title: Text(
                'Friendly with children',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isFriendlyWithChildren,
              onChanged: (bool value) {
                setState(() {
                  _isFriendlyWithChildren = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF967BB6),
            ),
            SwitchListTile(
              title: Text(
                'Spayed or neutered',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isSpayedOrNeutered,
              onChanged: (bool value) {
                setState(() {
                  _isSpayedOrNeutered = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF967BB6),
            ),
            SwitchListTile(
              title: Text(
                'Friendly with dogs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isFriendlyWithDogs,
              onChanged: (bool value) {
                setState(() {
                  _isFriendlyWithDogs = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF967BB6),
            ),
            SwitchListTile(
              title: Text(
                'House trained',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isHouseTrained,
              onChanged: (bool value) {
                setState(() {
                  _isHouseTrained = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF967BB6),
            ),
            SwitchListTile(
              title: Text(
                'Friendly with cats',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isFriendlyWithCats,
              onChanged: (bool value) {
                setState(() {
                  _isFriendlyWithCats = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF967BB6),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 10),
            Text('Care info',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                )),
            SizedBox(height: 20),
            // Inside the _AddPetPageState class, in the build method
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Number of walks per day',
                labelStyle: TextStyle(color: Colors.grey[500]),
                 hintText: 'Select Option', // Display hint text inside dropdown
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromRGBO(226, 225, 225, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF967BB6)),
                ),
              ),
              value: 'Not specified', // Default value
              onChanged: (String? newValue) {
                // Handle dropdown value change
                setState(() {
                  // Update the state with the new value
                });
              },
              items: <String>[
                'Not specified',
                'One walk per day',
                'Two walks per day',
                'Three walks per day',
                'Four walks per day',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                      value,
                      style: TextStyle(fontWeight: FontWeight.normal), // Set font weight to normal
                    ),
                );
              }).toList(),
            ),
              SizedBox(height: 20),
            // Inside the _AddPetPageState class, in the build method
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Energy level',
                labelStyle: TextStyle(color: Colors.grey[500]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromRGBO(226, 225, 225, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF967BB6)),
                ),
              ),
              value: 'Not specified', // Default value
              onChanged: (String? newValue) {
                // Handle dropdown value change
                setState(() {
                  // Update the state with the new value
                });
              },
              items: <String>[
                'Not specified',
                'High',
                'Medium',
                'Low',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                      value,
                      style: TextStyle(fontWeight: FontWeight.normal), // Set font weight to normal
                    ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text('Vet info',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                )),
            SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xFFCAADEE)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  maxLines: null, // Allows the text field to expand vertically
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText:
                        'Specify the deseases, the address of the clinic and the \nnumber of the veterinarian',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey), // Lighter color for hintText
                    border: InputBorder.none, // Remove default border
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MyButton(
                onTap: () {
                  // Handle form submission
                },
                text: 'Submit',
                color: Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: Color(0xFF967BB6),
                borderWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
