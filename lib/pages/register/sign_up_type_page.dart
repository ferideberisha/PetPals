import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // Light gray background
                    borderRadius: const BorderRadius.only(
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
                                    userType: 'owner',
                                    onTap: onTap, // Pass onTap to RegisterPage
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  Colors.white, // Set the text color to black
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60, // Adjust the width of the icon
                                  height: 60, // Adjust the height of the icon
                                  child: Image.asset('lib/images/dogowner.png'),
                                ),
                                const SizedBox(
                                    width:
                                        15), // Add space between the image and text
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
                                      'I want my pet to be taken care of', // Add your additional text here
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
                                    userType: 'walker',
                                    onTap: onTap, // Pass onTap to RegisterPage
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  Colors.white, // Set the text color to black
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60, // Adjust the width of the icon
                                  height: 60, // Adjust the height of the icon
                                  child:
                                      Image.asset('lib/images/dogwalker.png'),
                                ),
                                const SizedBox(
                                    width:
                                        15), // Add space between the image and text
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
                                      'I want to take care of pets', // Add your additional text here
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
