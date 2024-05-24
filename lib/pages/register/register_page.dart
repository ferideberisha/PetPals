import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/my_textfield.dart'; // Import MyTextField

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  final String userType; // Add userType parameter

  const RegisterPage({Key? key, required this.onTap, required this.userType})
      : super(key: key);

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
  bool isConfirmPasswordVisible = false; // Add a state variable for confirm password visibility
  bool isPrivacyPolicyChecked = false;
  bool isUserAgreementChecked = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() { // Add function to toggle confirm password visibility
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    'PetPals',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
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
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        MyTextField(
                          controller: firstNameController,
                          hintText: 'First name',
                          obscureText: false,
                          fillColor: Colors.white,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: lastNameController,
                          hintText: 'Last name',
                          obscureText: false,
                          fillColor: Colors.white,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          fillColor: Colors.white,
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Create password',
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
                        ),
                        SizedBox(height: 10),
                        MyTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm password',
                          obscureText: !isConfirmPasswordVisible, // Use separate state variable here
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: toggleConfirmPasswordVisibility, // Use separate function here
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      30), // Adjust the top padding as needed
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Set the inside color to white
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.15), // Shadow color
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(0,
                                          1), // Move the shadow downwards a bit
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
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'I agree to the Privacy Policy, confirm that I am 18 years of age or older, and consent to receive email communication.',
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
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, // Set the inside color to white
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.15), // Shadow color
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: Offset(0,
                                        2), // Adjust the offset to move the shadow downwards
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
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'I agree to the User Agreement',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        MyButton(
                          onTap: () => signUserUp(context),
                          text: 'Sign Up',
                          color: Color(0xFF967BB6),
                          textColor: Colors.white,
                          borderColor: Color(0xFF967BB6),
                          borderWidth: 1.0,
                        ),
                        SizedBox(height: 15),
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

  void signUserUp(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Display a dialog message
    void displayMessage(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );
    }

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

      // Update user's profile with first and last name
      await userCredential.user!.updateProfile(
          displayName:
              '${firstNameController.text} ${lastNameController.text}');

      // Clear text fields
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Pop loading circle
      Navigator.pop(context);

      // Navigate to the login page
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error to user
      displayMessage(context, e.code);
    }
  }
}

