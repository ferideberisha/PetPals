import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/petModel.dart';

class PetController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // Add a pet to Firestore (Owners only)
  Future<void> addPet(Pet pet, String userId, String role) async {
    try {
      String subCollection = 'ownerInfo';
      DocumentReference petDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId)
          .collection('pets')
          .doc(); // Auto-generated ID for each pet

      await petDocRef.set(pet.toMap());
    } catch (e) {
      throw Exception('Failed to add pet: $e');
    }
  }

  // Get a stream of pets for a specific owner with document IDs
  Stream<List<Map<String, dynamic>>> getPetsStreamWithId(
      String userId, String role) {
    if (userId.isEmpty || role.isEmpty) {
      throw ArgumentError('Invalid userId or role');
    }

    String subCollection = 'ownerInfo';
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(subCollection)
        .doc(userId)
        .collection('pets')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id, // Store the document ID
                'pet': Pet.fromMap(doc.data())
              };
            }).toList());
  }

  // Update a pet in Firestore using the document ID (Owners only)
  Future<void> updatePet(
      Pet pet, String userId, String role, String petId) async {
    try {
      String subCollection = 'ownerInfo';

      DocumentReference petDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId)
          .collection('pets')
          .doc(petId); // Use the provided petId to update the specific document

      await petDocRef.update(pet.toMap());
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  // Delete a pet from Firestore using the document ID (Owners only)
  Future<void> deletePet(String userId, String role, String petId) async {
    try {
      String subCollection = 'ownerInfo';

      DocumentReference petDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId)
          .collection('pets')
          .doc(petId); // Use the provided petId to delete the specific document

      await petDocRef.delete();
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  // Fetch pets for a specific user and role (Owners only)

  Future<List<Pet>> getPets(String userId, String role) async {
    List<Pet> pets = [];

    // Construct the path based on role
    String path = 'users/$userId/ownerInfo/$userId/pets';

    try {
      QuerySnapshot snapshot = await _firestore.collection(path).get();
      for (var doc in snapshot.docs) {
        pets.add(Pet.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print('Error fetching pets: $e');
      rethrow;
    }

    return pets;
  }

}
