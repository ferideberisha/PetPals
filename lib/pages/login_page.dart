import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/components/square_tile.dart';
import 'package:petpals/pages/sign_up_type_page.dart';
import 'package:petpals/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void signUserIn() async {
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
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
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
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Container(
          decoration: BoxDecoration(
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
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: !isPasswordVisible,
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
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
                          color: Color(0xFF967BB6),
                          textColor: Colors.white,
                          borderColor: Color(0xFF967BB6),
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
                            SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png')
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
                              fontSize: 14, // Matching font size
                              fontFamily: 'OpenSans', // Using the same Google Font
                              fontWeight: FontWeight.normal, // Matching font weight
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Colors.indigo.shade600,
                                  fontFamily: 'OpenSans', // Using the same Google Font
                                  fontSize: 14, // Matching font size
                                  fontWeight: FontWeight.normal, // Matching font weight
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle Terms of Service click
                                  },
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.indigo.shade600,
                                  fontFamily: 'OpenSans', // Using the same Google Font
                                  fontSize: 14, // Matching font size
                                  fontWeight: FontWeight.normal, // Matching font weight
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle Privacy Policy click
                                  },
                              ),
                              const TextSpan(
                                text: ', confirm that I am 18 years of age or older, and consent to receiving email communication. This site is protected by reCAPTCHA and the Google Privacy Policy and Terms of Service apply.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans', // Using the same Google Font
                                  fontSize: 14, // Matching font size
                                  fontWeight: FontWeight.normal, // Matching font weight
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                        const SizedBox(height: 40),
                    MyButton(
                        onTap: () {
                          // Navigate to the SignUpTypePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpTypePage(
                                onTap: () {
                                  // Navigate back to the LoginPage when needed
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        text: 'Sign Up',
                        color: Colors.transparent,
                        textColor: Color(0xFF967BB6),
                        borderColor: Color(0xFF967BB6),
                        borderWidth: 1.0,
                      ),

                      ],
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
