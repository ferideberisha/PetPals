import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/components/square_tile.dart';
import 'package:petpals/pages/register/sign_up_type_page.dart';
import 'package:petpals/service/auth_service.dart';

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

  void signUserIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
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
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        if (e.code == 'user-not-found') {
          showErrorDialog('You have entered an invalid username or password.');
        } else if (e.code == 'wrong-password') {
          showErrorDialog('You have entered an invalid username or password.');
        } else if (e.code == 'invalid-credential') {
          showErrorDialog('Invalid email or password.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF967BB6),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    'PetPals',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.exo2(
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
                            hintText: 'Password',
                            obscureText: !isPasswordVisible,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: togglePasswordVisibility,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8 || value.length > 32) {
                                return 'Password must be between 8 and 32 characters long';
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Password must contain at least one uppercase letter';
                              }
                              int digitCount = value
                                  .replaceAll(RegExp(r'[^0-9]'), '')
                                  .length;
                              if (digitCount < 2) {
                                return 'Password must contain at least two digits';
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
                                onTap: () {},
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
                                onTap: () => AuthService().signInWithGoogle(),
                                imagePath: 'lib/images/google.png',
                              ),
                              SquareTile(
                                  onTap: () {},
                                  imagePath: 'lib/images/apple.png')
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    'By signing in or signing up, I agree to the ',
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
                                        // Handle Terms of Service click
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
                                        // Handle Privacy Policy click
                                      },
                                  ),
                                  const TextSpan(
                                    text:
                                        ', confirm that I am 18 years of age or older, and consent to receiving email communication. This site is protected by reCAPTCHA and the Google Privacy Policy and Terms of Service apply.',
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
                          const SizedBox(height: 40),
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
      ),
    );
  }
}
