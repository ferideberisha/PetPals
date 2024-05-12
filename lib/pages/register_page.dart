import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isPrivacyPolicyChecked = false;
  bool isUserAgreementChecked = false;

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
          decoration: BoxDecoration(
            color: Color(0xFF967BB6),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
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
                          'Sign Up',
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
                          controller: firstNameController,
                          hintText: 'First name',
                          obscureText: false,
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: lastNameController,
                          hintText: 'Last name',
                          obscureText: false,
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Create password',
                          obscureText: !isPasswordVisible,
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm password',
                          obscureText: !isPasswordVisible,
                          fillColor: Color.fromRGBO(230, 230, 250, 0.5),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 20),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isPrivacyPolicyChecked,
                        onChanged: (value) {
                          setState(() {
                            isPrivacyPolicyChecked = value!;
                          });
                        },
                      ),
                      Flexible(
                        child: Text(
                          'I agree to the Privacy Policy, confirm that I am 18 years of age or older, and consent to receive email communication.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isUserAgreementChecked,
                              onChanged: (value) {
                                setState(() {
                                  isUserAgreementChecked = value!;
                                });
                              },
                            ),
                            const Text(
                              'I agree with the User Agreement',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          onTap: isPrivacyPolicyChecked && isUserAgreementChecked ? signUserUp : null,
                          text: 'Sign Up',
                          color: Color(0xFF967BB6),
                          textColor: Colors.white,
                          borderColor: Color(0xFF967BB6),
                          borderWidth: 1.0,
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          onTap: widget.onTap,
                          text: 'Back',
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

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage("Passwords don't match!");
    }

    //try creating the user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // Clear text fields
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      //pop loading circle
      if (context.mounted) Navigator.pop(context);

      // Invoke onTap function to navigate to login page
      widget.onTap?.call();
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage(e.code);
    }
  }

  //display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }
}
