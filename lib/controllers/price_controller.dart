import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/priceModel.dart';

class PriceController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setPrices(Prices prices, String userId, String role, String priceId) async {
    // Determine subcollection based on role
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';

    // Path to the specific price document inside the subcollection
    final path = 'users/$userId/$subCollection/$userId/price/$priceId';

    try {
      // Reference the specific price document
      final priceDocument = _db.doc(path);

      // Update the document with the Prices data
      await priceDocument.set(prices.toMap(), SetOptions(merge: true));
      print('Prices saved successfully');
    } catch (e) {
      print('Error setting prices: $e');
    }
  }

  Future<Prices?> getPrices(String userId, String role, String priceId) async {
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final path = 'users/$userId/$subCollection/$userId/price/$priceId';

    try {
      // Reference the specific price document
      final docSnapshot = await _db.doc(path).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Return the Prices object from the document data
        return Prices.fromMap(docSnapshot.data() as Map<String, dynamic>);
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
