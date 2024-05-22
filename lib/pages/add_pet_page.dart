import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/dropdown_list.dart';
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

  String? _selectedWalksPerDay = 'Not specified'; // Set default value

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
            SizedBox(height: 20),
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
                SizedBox(height: 10),
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
                        color:
                            _isMaleSelected ? Color(0xFFCAADEE) : Colors.white,
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
                        color: _isFemaleSelected
                            ? Color(0xFFCAADEE)
                            : Colors.white,
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
                    color: _selectedSizeRange == '1-5'
                        ? Color(0xFFCAADEE)
                        : Colors.white,
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
                    color: _selectedSizeRange == '5-10'
                        ? Color(0xFFCAADEE)
                        : Colors.white,
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
                    color: _selectedSizeRange == '10-15'
                        ? Color(0xFFCAADEE)
                        : Colors.white,
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
                    color: _selectedSizeRange == '15-20'
                        ? Color(0xFFCAADEE)
                        : Colors.white,
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
            SizedBox(height: 10),
            // Inside the Column widget, under the 'About the pet' text
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
                    hintText: 'Describe the nature of your pet and its habits',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey), // Lighter color for hintText
                    border: InputBorder.none, // Remove default border
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                'Microchipped',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isMicrochipped,
              onChanged: (value) {
                setState(() {
                  _isMicrochipped = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Friendly with Children',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isFriendlyWithChildren,
              onChanged: (value) {
                setState(() {
                  _isFriendlyWithChildren = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Spayed or Neutered',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isSpayedOrNeutered,
              onChanged: (value) {
                setState(() {
                  _isSpayedOrNeutered = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Friendly with Dogs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isFriendlyWithDogs,
              onChanged: (value) {
                setState(() {
                  _isFriendlyWithDogs = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'House Trained',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isHouseTrained,
              onChanged: (value) {
                setState(() {
                  _isHouseTrained = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Friendly with Cats',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              value: _isFriendlyWithCats,
              onChanged: (value) {
                setState(() {
                  _isFriendlyWithCats = value;
                });
              },
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text('Care info',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                )),
            SizedBox(height: 10),
            // Inside the Column widget, under the 'Vet info' text
            SizedBox(height: 10),
            CustomDropdownList(
              items: [
                'Number of walks per day',
                'Not specified',
                '1',
                '2',
                '3',
                '4',
                '5 or more',
              ],
              value: _selectedWalksPerDay,
              onChanged: (String? value) {
                setState(() {
                  _selectedWalksPerDay =
                      value ?? 'Not specified'; // Handle nullability
                });
              },
              itemStyles: [
                TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ), // 'Number of walks per day'
                if (_selectedWalksPerDay !=
                    'Not specified') // Check if 'Not specified' is selected
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ), // All other items
              ],
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
            // Inside the Column widget, under the 'About the pet' text
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
            MyButton(
              onTap: () {
                // Handle Add Pet logic here
                print('Add Pet button tapped!');
              },
              text: 'Add Pet',
              color: Color(0xFF967BB6), // Change the color as needed
              textColor: Colors.white,
              borderColor: Color(0xFF967BB6),
              borderWidth: 0,
            ),
          ],
        ),
      ),
    );
  }
}
