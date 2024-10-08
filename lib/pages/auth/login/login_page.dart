import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpals/components/header.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/components/square_tile.dart';
import 'package:petpals/pages/auth/register/sign_up_type_page.dart';
import 'package:petpals/service/auth_service.dart';
import 'package:petpals/pages/auth/login/forgot_password_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

void signUserIn() async {
  if (_formKey.currentState!.validate()) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Dismiss the loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      // Optionally navigate to the next page or handle successful login
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        showErrorDialog('You have entered an invalid username or password.');
      } else {
        showErrorDialog('An unexpected error occurred. Please try again.');
      }
    }
  }
}


  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri,  mode: LaunchMode.externalApplication);
  } else {
    showErrorDialog('Could not launch $url');
  }
}

Future<void> handleGoogleSignIn() async {
    try {
      User? user = await AuthService().signInWithGoogle(context);

      if (user != null) {
        // Optionally handle what happens after successful login
        print('User signed in: ${user.email}');
      } else {
        // Handle the case where the sign-in failed or was cancelled
        print('Google Sign-In failed');
        showErrorDialog('Google Sign-In failed. Please try again.');
      }
    } catch (e) {
      showErrorDialog('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderWidget(title: 'PetPals'),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign In',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          fillColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            bool isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
                            if (!isValidEmail) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: !isPasswordVisible,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: togglePasswordVisibility,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'Password must contain at least one lowercase letter';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Password must contain at least one digit';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                return 'Password must contain at least one symbol';
                              }
                              return null;
                            },
                          ),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.indigo.shade600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyButton(
                          onTap: signUserIn,
                          text: 'Sign in',
                          color: const Color(0xFF967BB6),
                          textColor: Colors.white,
                          borderColor: const Color(0xFF967BB6),
                          borderWidth: 1.0,
                          width: double.infinity,
                          height: 60,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SquareTile(
                              onTap: handleGoogleSignIn,
                              imagePath: 'lib/images/google.png',
                            ),
                            SquareTile(
                              onTap: () {},
                              imagePath: 'lib/images/apple.png',
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text: 'By signing in or signing up, I agree to the ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.normal,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: Colors.indigo.shade600,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchURL('https://www.termsfeed.com/live/a00075e3-7072-4e70-9e62-7e7b4b8a64ea');
                                    },
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.indigo.shade600,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchURL('https://www.termsfeed.com/live/a00075e3-7072-4e70-9e62-7e7b4b8a64ea'); // Change to the correct URL for Privacy Policy if needed
                                    },
                                ),
                                const TextSpan(
                                  text: ', confirm that I am 18 years of age or older, and consent to receiving email communication. This site is protected by reCAPTCHA and the Google Privacy Policy and Terms of Service apply.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        MyButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpTypePage(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                          text: 'Sign Up',
                          color: Colors.transparent,
                          textColor: const Color(0xFF967BB6),
                          borderColor: const Color(0xFF967BB6),
                          borderWidth: 1.0,
                          width: 390,
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}