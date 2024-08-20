import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/priceModel.dart';

class PriceController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setPrices(
    Prices prices,
    String userId,
    String role, {
    String? priceId, // Optional parameter for existing priceId
  }) async {
    try {
      final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      var userDoc = _firestore.collection('users').doc(userId);
      var infoCollection =
          userDoc.collection(subCollection).doc(userId).collection('price');

      // Use the provided priceId or create a new document if priceId is null
      var docRef =
          priceId != null ? infoCollection.doc(priceId) : infoCollection.doc();

      await docRef.set(
          prices.toMap(),
          SetOptions(
              merge:
                  true)); // Use merge to update existing fields or create new ones
      print('Prices saved successfully at ${docRef.id}');
    } catch (e) {
      print('Error saving prices: $e');
      rethrow;
    }
  }

  Future<Prices?> getPrices(String userId, String role, String priceId) async {
    try {
      final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId)
          .collection('price')
          .doc(priceId);

      final doc = await docRef.get();
      if (doc.exists) {
        return Prices.fromMap(doc.data()!);
      } else {
        print('Price document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching prices: $e');
      return null;
    }
  }
}