import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/aboutmeModel.dart';

class AboutMeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAboutMeData(AboutMeFormData aboutMeData, String userId, String role) async {
    try {
      // Ensure userId is not empty
      if (userId.isEmpty) {
        throw Exception("User ID is empty.");
      }

      // Determine the correct subcollection based on role
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

      // Reference to the user document and subcollection
      var userDoc = _firestore.collection('users').doc(userId);
      var infoCollection = userDoc.collection(subCollection).doc(userId).collection('aboutMe');

      // Generate a unique ID for the new document
      var docRef = infoCollection.doc();

      // Save the "About Me" data with the generated ID
      await docRef.set(aboutMeData.toMap());
      print('About Me data saved under path: ${docRef.path}');

    } catch (e) {
      throw Exception('Failed to save About Me data: $e');
    }
  }

  // Retrieve "About Me" data from Firestore
  Future<AboutMeFormData?> getAboutMeData(String userId, String role, String aboutMeId) async {
    try {
      // Ensure userId is not empty
      if (userId.isEmpty || aboutMeId.isEmpty) {
        throw Exception("User ID or About Me ID is empty.");
      }

      // Determine the correct subcollection based on role
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

      // Reference to the document that holds the "About Me" data
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection(subCollection)
              .doc(userId)
              .collection('aboutMe')
              .doc(aboutMeId)
              .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        return AboutMeFormData.fromMap(snapshot.data()!);
      }
    } catch (e) {
      throw Exception('Failed to get About Me data: $e');
    }
    return null;
  }

  updateAboutMeFormData(AboutMeFormData aboutMeData) {}
}
