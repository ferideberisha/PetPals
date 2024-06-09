import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/profile/basicinfo/basic_info_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final Function(String) verifyOTP;
  final String verificationId;
  final String phoneNumber;

  const OTPVerificationPage({super.key, required this.verifyOTP, required this.verificationId, required this.phoneNumber});

  @override
  // ignore: library_private_types_in_public_api
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : MyButton(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final cred = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: _otpController.text,
                        );

                        await FirebaseAuth.instance.signInWithCredential(cred);

                        // Update phone number in Firestore
                        await updateUserPhoneNumber(widget.phoneNumber);

                        // Navigate to the next page after successful verification
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(builder: (context) => const BasicInfoPage()), // Ensure HomePage is correctly implemented
                        );
                      } catch (e) {
                        log(e.toString()); // Print the error message
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification failed. Please try again.'),
                          ),
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    text: 'Verify OTP',
                    color: const Color(0xFF967BB6),
                    textColor: Colors.white,
                    borderColor: const Color(0xFF967BB6),
                    borderWidth: 1.0,
                    width: 390,
                    height: 60,
                  ),
          ],
        ),
      ),
    );
  }
  
  Future<void> updateUserPhoneNumber(String phoneNumber) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'phoneNumber': phoneNumber});
      }
    } catch (e) {
      rethrow; // Handle error appropriately
    }
  }
}
