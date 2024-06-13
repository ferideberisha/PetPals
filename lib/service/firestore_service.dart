import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/petModel.dart';

class FirestoreService {
  final CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('pets');

  // Fetch pets as a stream
  Stream<List<Pet>> getPetsStream() {
    return petsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // Add pet to Firestore
  Future<void> addPet(Pet pet) async {
    try {
      await petsCollection.add(pet.toMap());
    } catch (e) {
      print('Error adding pet: $e');
    }
  }
}
