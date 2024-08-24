import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:petpals/models/availabilityModel.dart';

class AvailabilityController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveAvailability(String userId, DateTime date, AvailabilityModel availability) async {
  try {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    await _firestore.collection('users')
        .doc(userId)
        .collection('walkerInfo')
        .doc(userId)
        .collection('availability')
        .doc(formattedDate)
        .set(availability.toMap());
  } catch (e) {
    print('Error saving availability: $e');
  }
}


  Future<AvailabilityModel?> getAvailability(String userId, DateTime date) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot doc = await _firestore.collection('users')
          .doc(userId)
          .collection('walkerInfo')
          .doc(userId)
          .collection('availability')
          .doc(formattedDate)
          .get();

      if (doc.exists) {
        return AvailabilityModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching availability: $e');
      return null;
    }
  }
}
