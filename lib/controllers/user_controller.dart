import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        await userDoc.collection('${role}Info').doc('placeholder').set({});
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

  // Update user information in Firestore
  Future<void> updateUser(
    String userId, {
    String? firstName,
    String? lastName,
    String? email,
    String? birthday,
    String? address, required String phoneNumber,
  }) async {
    try {
      // Create a map with the fields to update
      final Map<String, dynamic> updateData = {};
      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      // if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (email != null) updateData['email'] = email;
      if (birthday != null) updateData['birthday'] = birthday;
      if (address != null) updateData['address'] = address;

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update(updateData);
      }
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  // Delete a user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);

      // Example: Delete sub-collections (if any)
      final subCollectionRefs = ['walkerInfo', 'ownerInfo'];
      for (String subCollection in subCollectionRefs) {
        final subCollectionSnap = await userDoc.collection(subCollection).get();
        for (var doc in subCollectionSnap.docs) {
          await doc.reference
              .delete(); // Use doc.reference to delete the document
        }
      }

      // Delete the user document
      await userDoc.delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid; // The ID of the currently logged-in user (owner)
  } else {
    throw Exception("No user is currently logged in");
  }
  }
}