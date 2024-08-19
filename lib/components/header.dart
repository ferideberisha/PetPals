import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final double height; // New parameter for height

  const HeaderWidget({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF967BB6),
    this.textColor = Colors.white,
    this.height = 140.0, // Default height value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.25), // Adjust padding based on height
      color: backgroundColor,
      height: height, // Set the height of the header
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.exo2(
            textStyle: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
