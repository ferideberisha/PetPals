import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petpals/components/custom_switch.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/circle_avatar.dart'; // Import CircleAvatarWidget
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/controllers/pet_controller.dart';
import 'package:petpals/models/petModel.dart';

class AddPetPage extends StatefulWidget {
    final String userId;
 final String role;
  const AddPetPage({Key? key, required this.userId, required this.role}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddPetPageState createState() => _AddPetPageState();
  
}

class _AddPetPageState extends State<AddPetPage> {
  
 final PetController _petController = PetController();

  File? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Add this line
  final TextEditingController _vetInfoController = TextEditingController();

  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;
  String? _selectedSizeRange;
  bool _isMicrochipped = false;
  bool _isFriendlyWithChildren = false;
  bool _isSpayedOrNeutered = false;
  bool _isFriendlyWithDogs = false;
  bool _isHouseTrained = false;
  bool _isFriendlyWithCats = false;
  bool _isEnergyLevelError = false;

  String? _energyLevel; // Define _energyLevel here

  String? _numberOfWalksPerDay; // Define _energyLevel here
  bool _isNumberOfWalksError = false; // Add this boolean flag
  bool _isGenderError =
      false; // Flag to determine if gender error should be displayed
  bool _isSizeError = false;
  bool _isDescriptionError = false;

  final _formKey = GlobalKey<FormState>();

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
  _descriptionController.dispose(); // Dispose the _descriptionController
  super.dispose();
}


void _submitForm() {
     
  // Reset error flags and messages before validating the form
  setState(() {
    _isGenderError = false;
    _isSizeError = false;
    _isDescriptionError = false;
    _isNumberOfWalksError = false;
    _isEnergyLevelError = false;
  });

  // Validate the form
  if (!_formKey.currentState!.validate()) {
    return;
  }

  // Check if gender is selected
  if (!_isMaleSelected && !_isFemaleSelected) {
    setState(() {
      _isGenderError = true; // Set flag to display error
    });
    // Scroll to the gender buttons to make the error visible
    Scrollable.ensureVisible(context);
    return;
  }

  // Check if size range is selected
  if (_selectedSizeRange == null) {
    setState(() {
      _isSizeError = true; // Set flag to display error
    });
    return;
  }

  // Create a new Pet instance
  Pet newPet = Pet(
    name: _nameController.text,
    imagePath: _image?.path ?? '',
    age: int.parse(_ageController.text),
    gender: _isMaleSelected ? 'Male' : 'Female',
    sizeRange: _selectedSizeRange ?? '',
    description: _descriptionController.text,
    microchipped: _isMicrochipped,
    friendlyWithChildren: _isFriendlyWithChildren,
    spayedOrNeutered: _isSpayedOrNeutered,
    friendlyWithDogs: _isFriendlyWithDogs,
    houseTrained: _isHouseTrained,
    friendlyWithCats: _isFriendlyWithCats,
    numberOfWalksPerDay: _numberOfWalksPerDay ?? 'Not specified',
    energyLevel: _energyLevel ?? 'Not specified',
    vetInfo: _vetInfoController.text,
  );

// Save the pet to Firestore
_petController.addPet(newPet, widget.userId, widget.role).then((_) {
  Navigator.pop(context, newPet);
}).catchError((error) {
  print('Failed to add pet: $error');
});

  // Clear form fields after successful submission
  setState(() {
    _nameController.clear();
    _ageController.clear();
    _descriptionController.clear();
    _vetInfoController.clear();
    _image = null;
    _isMaleSelected = false;
    _isFemaleSelected = false;
    _selectedSizeRange = null;
    _isMicrochipped = false;
    _isFriendlyWithChildren = false;
    _isSpayedOrNeutered = false;
    _isFriendlyWithDogs = false;
    _isHouseTrained = false;
    _isFriendlyWithCats = false;
    _numberOfWalksPerDay = null;
    _energyLevel = null;
  });

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Pet added successfully'),
      duration: Duration(seconds: 2),
    ),
  );

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shadowColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _submitForm,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  Colors.transparent), // Remove hover effect
            ),
            child: const Text(
              'Submit',
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    icon: Icons.pets, // Use the paw icon
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        // Check if the input is a valid positive number and less than or equal to 20
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
                                    _isGenderError =
                                        false; // Reset gender error flag
                                  });
                                },
                                text: 'Male',
                                color: _isMaleSelected
                                    ? const Color(0xFFCAADEE)
                                    : Colors.white,
                                textColor: Colors.black,
                                borderColor: _isGenderError
                                    ? Colors.red
                                    : const Color(0xFFCAADEE),
                                borderWidth: 1,
                                validator: (_) {
                                  if (!_isMaleSelected && !_isFemaleSelected) {
                                    return 'Please select gender';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
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
                                    ? const Color(0xFFCAADEE)
                                    : Colors.white,
                                textColor: Colors.black,
                                borderColor: _isGenderError
                                    ? Colors.red
                                    : const Color(0xFFCAADEE),
                                borderWidth: 1,
                                validator: (_) {
                                  if (!_isMaleSelected && !_isFemaleSelected) {
                                    return 'Please select gender';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_isGenderError &&
                            !_isMaleSelected &&
                            !_isFemaleSelected)
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 10.0),
                              child: Text(
                                'Please select a gender',
                                style: TextStyle(
                                    //  color: Color.fromARGB(255, 184, 61, 54),
                                    color: Color.fromARGB(255, 175, 29, 29),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                      ],
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
                        borderColor:
                            _isSizeError ? Colors.red : const Color(0xFFCAADEE),
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
                        borderColor:
                            _isSizeError ? Colors.red : const Color(0xFFCAADEE),
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
                        borderColor:
                            _isSizeError ? Colors.red : const Color(0xFFCAADEE),
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
                        borderColor:
                            _isSizeError ? Colors.red : const Color(0xFFCAADEE),
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
                  CustomSwitchTile(
                  key: UniqueKey(), // Ensure widget rebuilds correctly
                  title: 'Microchipped',
                  initialValue: _isMicrochipped,
                  onChanged: (bool value) {
                    setState(() {
                      _isMicrochipped = value;
                    });
                  },
                ),

                CustomSwitchTile(
                   key: UniqueKey(),
                  title: 'Friendly with children',
                  initialValue: _isFriendlyWithChildren,
                  onChanged: (bool value) {
                    setState(() {
                      _isFriendlyWithChildren = value;
                    });
                  },
                ),
                CustomSwitchTile(
                   key: UniqueKey(),
                  title: 'Spayed or neutered',
                  initialValue: _isSpayedOrNeutered,
                  onChanged: (bool value) {
                    setState(() {
                      _isSpayedOrNeutered = value;
                    });
                  },
                ),
                CustomSwitchTile(
                   key: UniqueKey(),
                  title: 'Friendly with dogs',
                  initialValue: _isFriendlyWithDogs,
                  onChanged: (bool value) {
                    setState(() {
                      _isFriendlyWithDogs = value;
                    });
                  },
                ),
                CustomSwitchTile(
                   key: UniqueKey(),
                  title: 'House trained',
                  initialValue: _isHouseTrained,
                  onChanged: (bool value) {
                    setState(() {
                      _isHouseTrained = value;
                    });
                  },
                ),
                CustomSwitchTile(
                   key: UniqueKey(),
                  title: 'Friendly with cats',
                  initialValue: _isFriendlyWithCats,
                  onChanged: (bool value) {
                    setState(() {
                      _isFriendlyWithCats = value;
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
                  decoration: InputDecoration(
                    labelText: 'Number of walks per day',
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    fillColor: Colors.white, // Set the fill color to white
                    filled:
                        true, // Ensure the field is filled with the fill color
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isNumberOfWalksError
                            ? Colors.red
                            : const Color.fromRGBO(226, 225, 225, 1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isNumberOfWalksError
                            ? Colors.red
                            : const Color(0xFF967BB6),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  value: _numberOfWalksPerDay ?? 'Not specified',
                  onChanged: (String? newValue) {
                    setState(() {
                      _numberOfWalksPerDay = newValue;
                      _isNumberOfWalksError = false; // Reset error flag
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
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value == 'Not specified') {
                      setState(() {
                        _isNumberOfWalksError = true; // Set error flag
                      });
                    } else {
                      setState(() {
                        _isNumberOfWalksError = false; // Reset error flag
                      });
                      return null;
                    }
                    return null;
                  },
                ),
                if (_isNumberOfWalksError)
                  Container(
                    color: Colors.white, // Set the background color to white
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 10.0),
                        child: Text(
                          'Please select number of walks',
                          style: TextStyle(
                            color: Color.fromARGB(255, 175, 29, 29),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Energy level',
                    fillColor: Colors.white, // Set the fill color to white
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isEnergyLevelError
                            ? Colors.red
                            : const Color.fromRGBO(226, 225, 225, 1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isEnergyLevelError
                            ? Colors.red
                            : const Color(0xFF967BB6),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  value: _energyLevel ?? 'Not specified',
                  onChanged: (String? newValue) {
                    setState(() {
                      _energyLevel = newValue;
                      _isEnergyLevelError = false; // Reset error flag
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
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                  if (value == null || value == 'Not specified') {
                    setState(() {
                      _isEnergyLevelError = true; // Set error flag
                    });
                    return 'Please select energy level';
                  }
                  setState(() {
                    _isEnergyLevelError = false; // Reset error flag
                  });
                  return null;
                },

                ),
                if (_isEnergyLevelError)
                  Container(
                    color: Colors.white, // Set the background color to white
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 10.0),
                        child: Text(
                          'Please select energy level',
                          style: TextStyle(
                            color: Color.fromARGB(255, 175, 29, 29),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
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
      ),
    );
  }
}
