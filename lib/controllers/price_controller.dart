import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/priceModel.dart';

class PriceController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPrices(Prices prices, String userId, String role) async {
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final path = 'users/$userId/$subCollection/price'; // Correct path for price collection

    try {
      final priceCollection = _db.collection(path);

      // Check if there are existing documents
      final querySnapshot = await priceCollection.get();

      if (querySnapshot.docs.isEmpty) {
        // Create a new document with an auto-generated ID if none exists
        DocumentReference priceRef = priceCollection.doc(); // or specify a document ID
        await priceRef.set(prices.toMap());
      } else {
        // Optionally update existing documents if needed
        print('Price document already exists.');
      }
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
