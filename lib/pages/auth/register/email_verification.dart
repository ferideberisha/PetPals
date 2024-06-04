import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/home_page.dart';
import 'package:petpals/pages/auth/login/login_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final VoidCallback onTap;

  const VerifyEmailPage({super.key, required this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      // Show error message if email sending fails
      showSnackBar(e.toString());
      // Set canResendEmail to true so user can retry
      setState(() => canResendEmail = true);
    }
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage(
          context: context,
        ) // Navigate to HomePage if email is verified
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verify Email'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent to your email',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: canResendEmail ? sendVerificationEmail : null,
                  text: 'Resend email',
                  color: const Color(0xFF967BB6),
                  textColor: Colors.white,
                  borderColor: const Color(0xFF967BB6),
                  borderWidth: 1.0,
                  width: 390,
                  height: 60,
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    // Sign out the user
                    FirebaseAuth.instance.signOut();
                    // Navigate to the registration page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          onTap: () {},
                        ), // Replace RegisterPage with your registration page
                      ),
                    );
                  },
                  text: 'Cancel',
                  color: Colors.transparent,
                  textColor: const Color(0xFF967BB6),
                  borderColor: const Color(0xFF967BB6),
                  borderWidth: 1.0,
                  width:390,
                  height: 60,
                ),
              ],
            ),
          ),
        );
}
