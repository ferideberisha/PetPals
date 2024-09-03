import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petpals/components/header.dart';
import 'package:petpals/components/my_button.dart';
import 'register_page.dart'; // Import the RegisterPage

class SignUpTypePage extends StatelessWidget {
  final VoidCallback onTap;

  const SignUpTypePage({super.key, required this.onTap});

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
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Account type',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the RegisterPage with userType as 'owner'
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(
                                  role: 'owner',
                                  onTap: onTap, // Pass onTap to RegisterPage
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Color(0x0D967BB6), // Text color
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Border radius
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.asset('lib/images/dogowner.png'),
                              ),
                              const SizedBox(width: 15),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Owner',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'I want my pet to be taken care of',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'OpenSans',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the RegisterPage with userType as 'walker'
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(
                                  role: 'walker',
                                  onTap: onTap, // Pass onTap to RegisterPage
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Color(0x0D967BB6), // Text color
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Border radius
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Image.asset('lib/images/dogwalker.png'),
                              ),
                              const SizedBox(width: 15),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Walker',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'I want to take care of pets',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'OpenSans',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 300),
                      MyButton(
                        onTap: onTap,
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
            ],
          ),
        ),
      ),
    );
  }
}
