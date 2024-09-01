import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Google Fonts package

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to LoginPage after a 2-second delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login'); // Adjust route name as needed
    });

    return Scaffold(
      backgroundColor: Color(0xFF967BB6), // Light blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Title with Google Font
            Text(
              'PetPals',
              style: GoogleFonts.pacifico( // Use a Google Font
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Title color
              ),
            ),
            SizedBox(height: 20),
            // App Icon
            const Icon(
              Icons.pets, // Dog icon or paw print icon
              size: 80,
              color: Colors.white, // Icon color
            ),
            SizedBox(height: 20),
            // Tagline or additional text (optional)
            Text(
              'Your Best Friend’s New Best Friend',
              style: GoogleFonts.openSans( // Use another Google Font
                fontSize: 18,
                color: Colors.white70, // Tagline color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
