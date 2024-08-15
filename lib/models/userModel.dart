import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String profilePicture;
  final String phoneNumber;
  final String address;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.phoneNumber,
    required this.address
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? ''
    );
  }

  // Method to convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'profilePicture': profilePicture,
      'phoneNumber': phoneNumber,
      'address':address
    };
  }
}
