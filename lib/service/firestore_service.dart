// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:petpals/models/aboutmeModel.dart';
// import 'package:petpals/models/availabilityModel.dart';
// import 'package:petpals/models/petModel.dart';
// import 'package:petpals/models/priceModel.dart';
// import 'package:petpals/models/userModel.dart';
// import 'package:petpals/models/paymentModel.dart'; // Import Payment model

// class FirestoreService {
//   final CollectionReference petsCollection =
//       FirebaseFirestore.instance.collection('pets');
//   final CollectionReference aboutMeCollection =
//       FirebaseFirestore.instance.collection('aboutMe');
//   final CollectionReference usersCollection =
//       FirebaseFirestore.instance.collection('users');
//   final CollectionReference paymentsCollection =
//       FirebaseFirestore.instance.collection('payments'); // Add payments collection
//   final CollectionReference pricesCollection =
//       FirebaseFirestore.instance.collection('prices');
//   final CollectionReference availabilityCollection =
//       FirebaseFirestore.instance.collection('availability');
//   // Add user to Firestore
//   Future<void> addUser(UserModel user) async {
//     try {
//       await usersCollection.add(user.toMap());
//     } catch (e) {
//       print('Error adding user: $e');
//       // Handle error appropriately, e.g., throw or log
//     }
//   }

//   // Fetch pets as a stream
//   Stream<List<Pet>> getPetsStream() {
//     return petsCollection.snapshots().map((snapshot) => snapshot.docs
//         .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>))
//         .toList());
//   }

//   // Add pet to Firestore
//   Future<void> addPet(Pet pet) async {
//     try {
//       await petsCollection.add(pet.toMap());
//     } catch (e) {
//       print('Error adding pet: $e');
//       // Handle error appropriately, e.g., throw or log
//     }
//   }

//   // Fetch AboutMeFormData for a user
//   Future<AboutMeFormData?> fetchAboutMeFormData(String userId) async {
//     try {
//       DocumentSnapshot snapshot = await aboutMeCollection.doc(userId).get();

//       if (snapshot.exists) {
//         return AboutMeFormData.fromSnapshot(snapshot);
//       } else {
//         print('No About Me Data found for user with ID: $userId');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching About Me Data: $e');
//       return null;
//     }
//   }

//   // Update or create AboutMeFormData for a user
//   Future<void> updateAboutMeFormData(AboutMeFormData formData) async {
//     try {
//       await aboutMeCollection.doc(formData.userId).set(formData.toJson());
//     } catch (e) {
//       print('Error updating About Me Data: $e');
//       // Handle error appropriately, e.g., throw or log
//     }
//   }

//   // Add payment to Firestore
//   Future<void> addPayment(Payment payment) async {
//     try {
//       await paymentsCollection.add(payment.toMap());
//     } catch (e) {
//       print('Error adding payment: $e');
//       // Handle error appropriately, e.g., throw or log
//     }
//   }

//   Future<void> addPrices(Prices prices) async {
//     try {
//       await pricesCollection.doc('currentPrices').set(prices.toMap());
//       print('Prices added successfully');
//     } catch (e) {
//       print('Error adding prices to Firestore: $e');
//       throw e; // Propagate the error
//     }
//   }

//   Future<Prices?> fetchPrices() async {
//     try {
//       QuerySnapshot snapshot = await pricesCollection.get();
//       if (snapshot.docs.isNotEmpty) {
//         return Prices.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
//       } else {
//         print('No prices data found');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching prices: $e');
//       return null;
//     }
//   }
//   Future<double?> fetchWalkingPrice(String userId) async {
//     try {
//       DocumentSnapshot snapshot = await pricesCollection.doc(userId).get();
//       if (snapshot.exists) {
//         return (snapshot.data() as Map<String, dynamic>)['walkingPrice']?.toDouble();
//       } else {
//         print('No price data found for user with ID: $userId');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching walking price: $e');
//       return null;
//     }
//   }


//   Future<Prices> getPrices() async {
//     DocumentSnapshot doc = await pricesCollection.doc('currentPrices').get();
//     if (doc.exists) {
//       return Prices.fromMap(doc.data() as Map<String, dynamic>);
//     } else {
//       return Prices(); // Return default prices if none exist
//     }
//   }
//  Future<void> addAvailability(Availability availability) async {
//     try {
//       // Create a reference to the availability document using the date
//       DocumentReference availabilityRef = availabilityCollection.doc(availability.date.toString());

//       // Check if the document exists
//       DocumentSnapshot snapshot = await availabilityRef.get();
//       if (snapshot.exists) {
//         // Document exists, update it with new availability data
//         await availabilityRef.update({
//           'timeSlots': availability.timeSlots.map((slot) => slot.toMap()).toList(),
//           'isBusyAllDay': availability.isBusyAllDay,
//         });
//       } else {
//         // Document does not exist, create a new one
//         await availabilityRef.set({
//           'date': availability.date,
//           'timeSlots': availability.timeSlots.map((slot) => slot.toMap()).toList(),
//           'isBusyAllDay': availability.isBusyAllDay,
//         });
//       }

//       print('Availability added/updated successfully');
//     } catch (e) {
//       print('Error adding/updating availability: $e');
//       throw e; // Propagate the error
//     }
//   }

//   Future<Availability?> fetchAvailability(DateTime date) async {
//     try {
//       DocumentSnapshot snapshot = await availabilityCollection.doc(date.toString()).get();

//       if (snapshot.exists) {
//         // Convert Firestore data to Availability object
//         return Availability.fromMap(snapshot.data() as Map<String, dynamic>);
//       } else {
//         print('No availability data found for date: $date');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching availability: $e');
//       return null;
//     }
//   }

//   Future<void> addTimeSlot(DateTime date, TimeSlot timeSlot) async {
//     try {
//       DocumentReference availabilityRef = availabilityCollection.doc(date.toString());

//       DocumentSnapshot snapshot = await availabilityRef.get();
//       if (snapshot.exists) {
//         await availabilityRef.update({
//           'timeSlots': FieldValue.arrayUnion([timeSlot.toMap()]),
//         });
//       } else {
//         await availabilityRef.set({
//           'date': date,
//           'timeSlots': [timeSlot.toMap()],
//           'isBusyAllDay': false,
//         });
//       }

//       print('Time slot added successfully');
//     } catch (e) {
//       print('Error adding time slot: $e');
//       throw e;
//     }
//   }

//   Future<void> updateAvailability(Availability availability) async {
//     try {
//       DocumentReference availabilityRef = availabilityCollection.doc(availability.date.toString());

//       DocumentSnapshot snapshot = await availabilityRef.get();
//       if (snapshot.exists) {
//         await availabilityRef.update({
//           'timeSlots': availability.timeSlots.map((slot) => slot.toMap()).toList(),
//           'isBusyAllDay': availability.isBusyAllDay,
//         });
//       } else {
//         await availabilityRef.set({
//           'date': availability.date,
//           'timeSlots': availability.timeSlots.map((slot) => slot.toMap()).toList(),
//           'isBusyAllDay': availability.isBusyAllDay,
//         });
//       }

//       print('Availability updated successfully');
//     } catch (e) {
//       print('Error updating availability: $e');
//       throw e;
//     }
//   }
// }