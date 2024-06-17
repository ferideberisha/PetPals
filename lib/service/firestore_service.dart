import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/aboutmeModel.dart';
import 'package:petpals/models/petModel.dart';
import 'package:petpals/models/userModel.dart';

class FirestoreService {
  final CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('pets');
  final CollectionReference aboutMeCollection =
      FirebaseFirestore.instance.collection('aboutMeFormData');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Add user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await usersCollection.add(user.toMap());
    } catch (e) {
      print('Error adding user: $e');
      // Handle error appropriately, e.g., throw or log
    }
  }

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
      // Handle error appropriately, e.g., throw or log
    }
  }

  // Fetch AboutMeFormData for a user
  Future<AboutMeFormData?> fetchAboutMeFormData(String userId) async {
    try {
      DocumentSnapshot snapshot = await aboutMeCollection.doc(userId).get();

      if (snapshot.exists) {
        return AboutMeFormData.fromSnapshot(snapshot);
      } else {
        print('No About Me Data found for user with ID: $userId');
        return null;
      }
    } catch (e) {
      print('Error fetching About Me Data: $e');
      return null;
    }
  }

  // Update or create AboutMeFormData for a user
  Future<void> updateAboutMeFormData(AboutMeFormData formData) async {
    try {
      await aboutMeCollection.doc(formData.userId).set(formData.toJson());
    } catch (e) {
      print('Error updating About Me Data: $e');
      // Handle error appropriately, e.g., throw or log
    }
  }
}
