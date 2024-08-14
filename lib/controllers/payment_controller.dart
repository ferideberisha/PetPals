import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/paymentModel.dart';

class PaymentController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Adds or updates a payment based on the user role
  Future<void> addPayment(Payment payment, String userId, String role) async {
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final path = 'users/$userId/$subCollection/$userId/payments';

    try {
      // Create a new document with an auto-generated ID
      DocumentReference paymentRef = _db.collection(path).doc();

      // Set payment data in the new document
      await paymentRef.set(payment.toMap());
    } catch (e) {
      print('Error adding payment: $e');
    }
  }

  // Stream that listens for real-time updates to the user's payment methods
  Stream<List<Payment>> getPaymentsStream(String userId, String role) {
    final subCollection = role == 'walker' ? 'walkerInfo' : 'ownerInfo';
    final path = 'users/$userId/$subCollection/$userId/payments';

    return _db.collection(path).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
