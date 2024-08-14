import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/petModel.dart';

class PetController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a pet to Firestore
  Future<void> addPet(Pet pet, String userId, String role) async {
    try {
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      // Add pet directly to the pets collection under the user's role-specific subcollection
      DocumentReference petDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId) // Use 'pets' document to create a pets collection
          .collection('pets')
          .doc(); // Auto-generated ID for each pet

      await petDocRef.set(pet.toMap());
    } catch (e) {
      throw Exception('Failed to add pet: $e');
    }
  }

  // Get a stream of pets for a specific user
  Stream<List<Pet>> getPetsStream(String userId, String role) {
    if (userId.isEmpty || role.isEmpty) {
      throw ArgumentError('Invalid userId or role');
    }

    String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(subCollection)
        .doc(userId) // Use 'pets' document to create a pets collection
        .collection('pets')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
