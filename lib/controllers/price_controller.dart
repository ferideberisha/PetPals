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

   // Method to fetch enabled services with prices
  Future<Map<String, double>> getEnabledServicesWithPrices(String userId, String role) async {
    try {
      final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
      final priceDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection(subCollection)
          .doc(userId)
          .collection('price')
          .doc('servicePrices') // Assuming you store the prices in a document with this ID
          .get();

      if (priceDoc.exists) {
        Prices prices = Prices.fromMap(priceDoc.data()!);
        Map<String, double> enabledServices = {};

        if (prices.dayCareEnabled && prices.dayCarePrice != null) {
          enabledServices['Day Care'] = prices.dayCarePrice!;
        }
        if (prices.houseSittingEnabled && prices.houseSittingPrice != null) {
          enabledServices['House Sitting'] = prices.houseSittingPrice!;
        }
        if (prices.walkingEnabled && prices.walkingPrice != null) {
          enabledServices['Walking'] = prices.walkingPrice!;
        }
        // Add more services as needed

        return enabledServices;
      } else {
        print('No price document found');
        return {};
      }
    } catch (e) {
      print('Error fetching enabled services: $e');
      return {};
    }
  }

  
}