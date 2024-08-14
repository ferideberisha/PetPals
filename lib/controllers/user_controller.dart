import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/userModel.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a user in Firestore with an auto-generated user ID
  Future<String?> createUser(String name, String email, String role) async {
    try {
      // Create a new document with an auto-generated ID
      DocumentReference userDoc = _firestore.collection('users').doc();
      String userId = userDoc.id; // Retrieve the auto-generated ID

      // Set the user document data
      await userDoc.set({
        'name': name,
        'email': email,
        'role': role,
      });

      // Set up sub-collections based on role
      if (role == 'walker' || role == 'owner') {
        await userDoc.collection(role + 'Info').doc('placeholder').set({});
      }

      // Return the generated user ID
      return userId;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  // Fetch a user from Firestore
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return UserModel.fromDocument(snapshot);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Add a user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error adding user: $e');
    }
  }
}
