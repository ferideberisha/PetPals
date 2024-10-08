import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/header.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/pages/auth/register/email_verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/userModel.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  final String role; // Add userType parameter

  const RegisterPage({super.key, required this.onTap, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isPrivacyPolicyChecked = false;
  bool isUserAgreementChecked = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
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
                const HeaderWidget(title: 'PetPals'), // Use HeaderWidget here
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
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          MyTextField(
                            controller: firstNameController,
                            hintText: 'First name',
                            obscureText: false,
                            fillColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          MyTextField(
                            controller: lastNameController,
                            hintText: 'Last name',
                            obscureText: false,
                            fillColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                            fillColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Regular expression for email validation
                              bool isValidEmail =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value);
                              if (!isValidEmail) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          MyTextField(
  controller: passwordController,
  hintText: 'Create password',
  obscureText: !isPasswordVisible,
  fillColor: Colors.white,
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
  suffixIcon: IconButton(
    icon: Icon(
      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      color: Colors.grey,
    ),
    onPressed: togglePasswordVisibility,
  ),
),

                          const SizedBox(height: 10),
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm password',
                            obscureText: !isConfirmPasswordVisible,
                            fillColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: toggleConfirmPasswordVisibility,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Checkbox(
          value: isPrivacyPolicyChecked,
          onChanged: (value) {
            setState(() {
              isPrivacyPolicyChecked = value!;
            });
          },
        ),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: RichText(
        text: TextSpan(
          text: 'I agree to the ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: Colors.indigo.shade600,
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none, // Underline for URL
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL('https://www.termsfeed.com/live/a00075e3-7072-4e70-9e62-7e7b4b8a64ea');
                },
            ),
            const TextSpan(
              text: ', confirm that I am 18 years of age or older, and consent to receiving email communication.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

                          const SizedBox(height: 10),
                         Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Checkbox(
        value: isUserAgreementChecked,
        onChanged: (value) {
          setState(() {
            isUserAgreementChecked = value!;
          });
        },
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: RichText(
        text: TextSpan(
          text: 'I agree to the ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.normal,
          ),
          children: [
            TextSpan(
              text: 'User Agreement',
              style: TextStyle(
                color: Colors.indigo.shade600,
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none, // Underline for URL
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL('https://www.termsfeed.com/live/a00075e3-7072-4e70-9e62-7e7b4b8a64ea'); // Change to the correct URL for User Agreement
                },
            ),
            const TextSpan(
              text: ', confirm that I am 18 years of age or older, and consent to receive email communication.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

                          const SizedBox(height: 15),
                          MyButton(
                            onTap: () => signUserUp(context),
                            text: 'Sign Up',
                            color: const Color(0xFF967BB6),
                            textColor: Colors.white,
                            borderColor: const Color(0xFF967BB6),
                            borderWidth: 1.0,
                            width: 390,
                            height: 60,
                          ),
                          const SizedBox(height: 15),
                          MyButton(
                            onTap: widget.onTap,
                            text: 'Back',
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

  // Display a dialog message
  void displayMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  void signUserUp(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    if (!isPrivacyPolicyChecked || !isUserAgreementChecked) {
      // If either checkbox is not checked, display an error message
      displayMessage(context,
          "Please agree to both the Privacy Policy and User Agreement.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error to user
      displayMessage(context, "Passwords don't match!");
      return; // Exit function early if passwords don't match
    }

    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        role: widget.role, 
        profilePicture: '', 
        phoneNumber: '',
        address: ''
      );

      // Save user data to Firestore
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.set(user.toMap());



      // Clear text fields
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Pop loading circle
      Navigator.pop(context);

      // Navigate to the email verification page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmailPage(
            onTap: () {}, // Provide an appropriate onTap callback
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error to user
      displayMessage(context, e.code);
    } catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Handle other exceptions
      displayMessage(context, "An error occurred. Please try again later.");
    }
  }
}
Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri,  mode: LaunchMode.externalApplication);
  } else {
    print('Could not launch $url');
  }
}
}
