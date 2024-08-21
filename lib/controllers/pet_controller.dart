import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/petModel.dart';

class PetController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a pet to Firestore
  Future<void> addPet(Pet pet, String userId, String role) async {
    try {
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
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

  // Get a stream of pets for a specific user with document IDs
  Stream<List<Map<String, dynamic>>> getPetsStreamWithId(
      String userId, String role) {
    if (userId.isEmpty || role.isEmpty) {
      throw ArgumentError('Invalid userId or role');
    }

    String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
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

  // Update a pet in Firestore using the document ID
  Future<void> updatePet(
      Pet pet, String userId, String role, String petId) async {
    try {
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

      DocumentReference petDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId)
          .collection('pets')
          .doc(petId); // Use the provided petId to update the specific document

      await petDocRef
          .update(pet.toMap()); // Ensure using the correct method here
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  // Delete a pet from Firestore using the document ID
  Future<void> deletePet(String userId, String role, String petId) async {
    try {
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

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
}