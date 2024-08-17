import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/aboutmeModel.dart';

class AboutMeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getAboutMeId(String userId, String role) async {
    // Logic to check if a document exists and return its ID
    String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection(subCollection)
        .doc(userId)
        .collection('aboutMe')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<String> createAboutMeData(AboutMeFormData aboutMeData, String userId, String role) async {
    String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    var userDoc = _firestore.collection('users').doc(userId);
    var infoCollection = userDoc.collection(subCollection).doc(userId).collection('aboutMe');

    var docRef = infoCollection.doc();
    await docRef.set(aboutMeData.toMap());
    return docRef.id;
  }

  Future<void> updateAboutMeData(AboutMeFormData aboutMeData, String userId, String role, String aboutMeId) async {
    String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    var userDoc = _firestore.collection('users').doc(userId);
    var infoCollection = userDoc.collection(subCollection).doc(userId).collection('aboutMe');

    await infoCollection.doc(aboutMeId).update(aboutMeData.toMap());
  }

  // Retrieve "About Me" data from Firestore
  Future<AboutMeFormData?> getAboutMeData(String userId, String role, String aboutMeId) async {
    try {
      String subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection(subCollection)
              .doc(userId)
              .collection('aboutMe')
              .doc(aboutMeId)
              .get();

      if (snapshot.exists && snapshot.data() != null) {
        return AboutMeFormData.fromMap(snapshot.data()!);
      }
    } catch (e) {
      throw Exception('Failed to get About Me data: $e');
    }
    return null;
  }
}
