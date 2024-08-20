import 'dart:io';

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

  File? _image;
  final PetController _petController = PetController();

  bool _isGenderError = false;
  bool _isSizeError = false;

  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  String? _selectedSizeRange;

  final List<String> _sizeRange = ['1-5', '5-10', '10-15', '15-20'];

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

  if (widget.pet.imagePath.isNotEmpty) {
    _image = File(widget.pet.imagePath);
  }
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
        Pet updatedPet = Pet(
          name: _nameController.text,
          imagePath: _image?.path ?? '',
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
    image: _image, // Ensure this is set correctly
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
                children: _sizeRange.map((range) {
                  return Expanded(
                    child: MyButton(
                      onTap: () {
                        setState(() {
                          _selectedSizeRange = range;
                          _isSizeError = false;
                        });
                      },
                      text: range,
                      color: _selectedSizeRange == range ? const Color(0xFFCAADEE) : Colors.white,
                      textColor: Colors.black,
                      borderColor: _isSizeError ? Colors.red : const Color(0xFFCAADEE),
                      borderWidth: 1,
                    ),
                  );
                }).toList(),
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
              const SizedBox(height: 10),
              MyTextField(
                controller: _descriptionController,
                hintText: 'Description',
                obscureText: false,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
                 const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _numberOfWalksPerDayController.text.isNotEmpty ? _numberOfWalksPerDayController.text : null,
              decoration: const InputDecoration(
                labelText: 'Number of Walks Per Day',
                fillColor: Colors.white,
                filled: true,
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
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
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
              decoration: const InputDecoration(
                labelText: 'Energy Level',
                fillColor: Colors.white,
                filled: true,
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
     
            ],
          ),
        ),
      ),
    );
  }
}
