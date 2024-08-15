// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AddPhoneNumberPage extends StatefulWidget {
//   @override
//   _AddPhoneNumberPageState createState() => _AddPhoneNumberPageState();
// }

// class _AddPhoneNumberPageState extends State<AddPhoneNumberPage> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController(); // Add OTP controller
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _verificationId; // Store the verification ID

//   void _signInWithPhoneNumber() async {
//     final phoneNumber = _phoneController.text;

//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         Navigator.of(context).pop(phoneNumber); // Return the phone number
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification failed: ${e.message}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Verification failed: ${e.message}')),
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId; // Store the verification ID
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Verification code sent to $phoneNumber')),
//         );
//         _showOtpDialog(); // Show OTP input dialog
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Handle timeout
//         setState(() {
//           _verificationId = verificationId;
//         });
//       },
//     );
//   }

//   void _verifyOtp(String otp) async {
//     if (_verificationId != null) {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: otp,
//       );

//       try {
//         await _auth.signInWithCredential(credential);
//         Navigator.of(context).pop(_phoneController.text); // Return the phone number
//       } catch (e) {
//         print('OTP verification failed: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('OTP verification failed')),
//         );
//       }
//     }
//   }

//   void _showOtpDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter OTP'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _otpController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter OTP code',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 final otp = _otpController.text;
//                 _verifyOtp(otp); // Verify the OTP code
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Verify'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Phone Number'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 hintText: 'Enter phone number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _signInWithPhoneNumber,
//               child: Text('Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
