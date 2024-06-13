class Pet {
  String name;
  String imagePath;
  int age;
  String gender;
  String sizeRange;
  String description;
  bool microchipped;
  bool friendlyWithChildren;
  bool spayedOrNeutered;
  bool friendlyWithDogs;
  bool houseTrained;
  bool friendlyWithCats;
  String numberOfWalksPerDay;
  String energyLevel;
  String vetInfo;

  Pet({
    required this.name,
    required this.imagePath,
    required this.age,
    required this.gender,
    required this.sizeRange,
    required this.description,
    required this.microchipped,
    required this.friendlyWithChildren,
    required this.spayedOrNeutered,
    required this.friendlyWithDogs,
    required this.houseTrained,
    required this.friendlyWithCats,
    required this.numberOfWalksPerDay,
    required this.energyLevel,
    required this.vetInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'age': age,
      'gender': gender,
      'sizeRange': sizeRange,
      'description': description,
      'microchipped': microchipped,
      'friendlyWithChildren': friendlyWithChildren,
      'spayedOrNeutered': spayedOrNeutered,
      'friendlyWithDogs': friendlyWithDogs,
      'houseTrained': houseTrained,
      'friendlyWithCats': friendlyWithCats,
      'numberOfWalksPerDay': numberOfWalksPerDay,
      'energyLevel': energyLevel,
      'vetInfo': vetInfo,
    };
  }

  // Static method to create a Pet object from a Map retrieved from Firestore
  static Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      name: map['name'],
      imagePath: map['imagePath'],
      age: map['age'],
      gender: map['gender'],
      sizeRange: map['sizeRange'],
      description: map['description'],
      microchipped: map['microchipped'],
      friendlyWithChildren: map['friendlyWithChildren'],
      spayedOrNeutered: map['spayedOrNeutered'],
      friendlyWithDogs: map['friendlyWithDogs'],
      houseTrained: map['houseTrained'],
      friendlyWithCats: map['friendlyWithCats'],
      numberOfWalksPerDay: map['numberOfWalksPerDay'],
      energyLevel: map['energyLevel'],
      vetInfo: map['vetInfo'],
    );
  }
}
