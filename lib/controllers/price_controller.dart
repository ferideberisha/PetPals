import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/priceModel.dart';

class PriceController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Adds or updates prices based on the user role
  Future<void> addPrices(Prices prices, String userId, String role) async {
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final path = 'users/$userId/$subCollection/$userId/price';

   try {
      // Create a new document with an auto-generated ID
      DocumentReference priceRef = _db.collection(path).doc();

      // Set prices data in the new document
      await priceRef.set(prices.toMap());
    } catch (e) {
      print('Error adding prices: $e');
    }
  }

 // Fetches all price documents for a user based on their role
  Future<List<Prices>> getPrices(String userId, String role) async {
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final path = 'users/$userId/$subCollection/$userId/price';

    try {
      // Fetch all price documents
      final querySnapshot = await _db.collection(path).get();

      // Convert all fetched documents to a list of Prices
      return querySnapshot.docs.map((doc) {
        return Prices.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching prices: $e');
      return [];
    }
  }
}
