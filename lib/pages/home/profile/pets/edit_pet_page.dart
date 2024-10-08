import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/circle_avatar.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/controllers/pet_controller.dart';
import 'package:petpals/models/petModel.dart';
import 'package:petpals/components/my_button.dart'; // Ensure this import is present

class EditPetPage extends StatefulWidget {
  final Pet pet;
  final String petId;
  final String userId;
  final String role;

  EditPetPage({
    super.key,
    required this.pet,
    required this.petId,
    required this.userId,
    required this.role,
  });

  @override
  _EditPetPageState createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;
  late TextEditingController _numberOfWalksPerDayController;
  late TextEditingController _energyLevelController;
  late TextEditingController _vetInfoController;

  String? _imageUrl; // Use URL instead of File
  File? _image;
  final PetController _petController = PetController();

  bool _isGenderError = false;
  bool _isSizeError = false;
  bool _isDescriptionError = false;

  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  String? _selectedSizeRange;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _descriptionController = TextEditingController(text: widget.pet.description);
    _numberOfWalksPerDayController = TextEditingController(text: widget.pet.numberOfWalksPerDay);
    _energyLevelController = TextEditingController(text: widget.pet.energyLevel);
    _vetInfoController = TextEditingController(text: widget.pet.vetInfo);

    _isMaleSelected = widget.pet.gender == 'Male';
    _isFemaleSelected = widget.pet.gender == 'Female';
    _selectedSizeRange = widget.pet.sizeRange;

    // Set image URL if available
    _imageUrl = widget.pet.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _numberOfWalksPerDayController.dispose();
    _energyLevelController.dispose();
    _vetInfoController.dispose();
    super.dispose();
  }

  Future<void> _updatePet() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl;

        // Upload new image if available
        if (_image != null) {
          imageUrl = await _uploadImage(_image!);
        } else {
          imageUrl = _imageUrl; // Retain the existing image URL
        }

        Pet updatedPet = Pet(
          name: _nameController.text,
          imagePath: imageUrl ?? '', // Use the uploaded or existing image URL
          age: int.parse(_ageController.text),
          gender: _isMaleSelected ? 'Male' : 'Female',
          sizeRange: _selectedSizeRange!,
          description: _descriptionController.text,
          microchipped: widget.pet.microchipped,
          friendlyWithChildren: widget.pet.friendlyWithChildren,
          spayedOrNeutered: widget.pet.spayedOrNeutered,
          friendlyWithDogs: widget.pet.friendlyWithDogs,
          houseTrained: widget.pet.houseTrained,
          friendlyWithCats: widget.pet.friendlyWithCats,
          numberOfWalksPerDay: _numberOfWalksPerDayController.text,
          energyLevel: _energyLevelController.text,
          vetInfo: _vetInfoController.text,
        );

        await _petController.updatePet(
          updatedPet,
          widget.userId,
          widget.role,
          widget.petId,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet updated successfully!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update pet: $e')),
        );
      }
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

  Future<String?> _uploadImage(File image) async {
    try {
      final String fileName = '${DateTime.now().toIso8601String()}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('pet_images/$fileName');
      final uploadTask = storageRef.putFile(image);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shadowColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _updatePet,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  Colors.transparent), // Remove hover effect
            ),
            child: const Text(
              'Update',
              style: TextStyle(
                color: Color(
                    0xFF967BB6), // Set the text color to the desired color
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
          child: ListView(
            children: [
              Center(
                child: CircleAvatarWidget(
                  pickImage: _pickImage,
                  image: _imageUrl != null
                      ? NetworkImage(_imageUrl!) // Use NetworkImage for URL
                      : _image != null
                          ? FileImage(_image!)
                          : null, // Default placeholder
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
                  icon: Icons.pets,
                ),
              ),

              const SizedBox(height: 20),
                              const Divider(),
                const SizedBox(height: 10),
                  const Text(
                      'Name, age',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
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
              const SizedBox(height: 10),
              MyTextField(
                controller: _ageController,
                hintText: 'Age',
                obscureText: false,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s age';
                  }
                  if (int.tryParse(value) == null ||
                      int.parse(value) <= 0 ||
                      int.parse(value) > 20) {
                    return 'Please enter a valid age (1-20)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text('Gender', style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          onTap: () {
                            setState(() {
                              _isMaleSelected = true;
                              _isFemaleSelected = false;
                              _isGenderError = false; // Reset gender error flag
                            });
                          },
                          text: 'Male',
                          color: _isMaleSelected ? const Color(0xFFCAADEE) : Colors.white,
                          textColor: Colors.black,
                          borderColor: _isGenderError ? Colors.red : const Color(0xFFCAADEE),
                          borderWidth: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyButton(
                          onTap: () {
                            setState(() {
                              _isMaleSelected = false;
                              _isFemaleSelected = true;
                              _isGenderError = false; // Reset gender error flag
                            });
                          },
                          text: 'Female',
                          color: _isFemaleSelected ? const Color(0xFFCAADEE) : Colors.white,
                          textColor: Colors.black,
                          borderColor: _isGenderError ? Colors.red : const Color(0xFFCAADEE),
                          borderWidth: 1,
                        ),
                      ),
                    ],
                  ),
                  if (_isGenderError && !_isMaleSelected && !_isFemaleSelected)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 10.0),
                        child: Text(
                          'Please select a gender',
                          style: TextStyle(
                            color: Color.fromARGB(255, 175, 29, 29),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
             Text('Size (kg)', style: TextStyle(color: Colors.grey[700])),
const SizedBox(height: 10),
Row(
  children: [
    Expanded(
      child: MyButton(
        onTap: () {
          setState(() {
            _selectedSizeRange = '1-5';
            _isSizeError = false;
          });
        },
        text: '1-5',
        color: _selectedSizeRange == '1-5'
            ? const Color(0xFFCAADEE)
            : Colors.white,
        textColor: Colors.black,
        borderColor: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
        borderWidth: 1,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: MyButton(
        onTap: () {
          setState(() {
            _selectedSizeRange = '5-10';
            _isSizeError = false;
          });
        },
        text: '5-10',
        color: _selectedSizeRange == '5-10'
            ? const Color(0xFFCAADEE)
            : Colors.white,
        textColor: Colors.black,
        borderColor: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
        borderWidth: 1,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: MyButton(
        onTap: () {
          setState(() {
            _selectedSizeRange = '10-15';
            _isSizeError = false;
          });
        },
        text: '10-15',
        color: _selectedSizeRange == '10-15'
            ? const Color(0xFFCAADEE)
            : Colors.white,
        textColor: Colors.black,
        borderColor: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
        borderWidth: 1,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: MyButton(
        onTap: () {
          setState(() {
            _selectedSizeRange = '15-20';
            _isSizeError = false;
          });
        },
        text: '15-20',
        color: _selectedSizeRange == '15-20'
            ? const Color(0xFFCAADEE)
            : Colors.white,
        textColor: Colors.black,
        borderColor: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
        borderWidth: 1,
      ),
    ),
  ],
),
if (_isSizeError && _selectedSizeRange == null)
  const Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.only(top: 8.0, left: 10.0),
      child: Text(
        'Please select a size range',
        style: TextStyle(
          color: Color.fromARGB(255, 175, 29, 29),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),

             const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'About the pet',
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
                      color: _isDescriptionError
                          ? Colors.red
                          : const Color(0xFFCAADEE),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                        controller: _descriptionController,
                      maxLines:
                          null, // Allows the text field to expand vertically
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText:
                            'Describe the nature of your pet and its habits',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none, // Remove default border
                        errorBorder: InputBorder.none, // Remove error border
                        focusedErrorBorder:
                            InputBorder.none, // Remove focused error border
                      ),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          _isDescriptionError = true; // Set flag to display error
                        });
                        return ;
                      }
                      setState(() {
                        _isDescriptionError = false; // Reset error flag
                      });
                      return null;
                    },

                    ),
                  ),
                ),
                if (_isDescriptionError)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 10.0),
                      child: Text(
                        'Please describe your pet',
                        style: TextStyle(
                          color: Color.fromARGB(255, 175, 29, 29),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
            SwitchListTile(
              title: const Text('Microchipped'),
              value: widget.pet.microchipped,
              onChanged: (bool value) {
                setState(() {
                  widget.pet.microchipped = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Friendly with Children'),
              value: widget.pet.friendlyWithChildren,
              onChanged: (bool value) {
                setState(() {
                  widget.pet.friendlyWithChildren = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Spayed or Neutered'),
              value: widget.pet.spayedOrNeutered,
              onChanged: (bool value) {
                setState(() {
                  widget.pet.spayedOrNeutered = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Friendly with Dogs'),
              value: widget.pet.friendlyWithDogs,
              onChanged: (bool value) {
                setState(() {
                  widget.pet.friendlyWithDogs = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('House Trained'),
              value: widget.pet.houseTrained,
              onChanged: (bool value) {
                setState(() {
                  widget.pet.houseTrained = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Friendly with Cats'),
              value: widget.pet.friendlyWithCats,
              onChanged: (bool value) {
                setState(() {
                  widget.pet.friendlyWithCats = value;
                });
              },
            ),
                  const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Care info',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
           DropdownButtonFormField<String>(
  value: _numberOfWalksPerDayController.text.isNotEmpty ? _numberOfWalksPerDayController.text : null,
  decoration: InputDecoration(
    labelText: 'Number of Walks Per Day',
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: const Color(0xFFCAADEE),
        width: 1.0,
      ),
    ),
  ),
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
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _numberOfWalksPerDayController.text = newValue ?? '';
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select number of walks per day';
    }
    return null;
  },
),
const SizedBox(height: 10),
DropdownButtonFormField<String>(
  value: _energyLevelController.text.isNotEmpty ? _energyLevelController.text : null,
  decoration: InputDecoration(
    labelText: 'Energy Level',
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: const Color(0xFFCAADEE),
        width: 1.0,
      ),
    ),
  ),
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
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _energyLevelController.text = newValue ?? '';
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select energy level';
    }
    return null;
  },
),

             const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Vet info',
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
                      controller: _vetInfoController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Specify the diseases, the address of the clinic and the \nnumber of the veterinarian',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
     
            ],
          ),
        ),
      ),
    );
  }
}
