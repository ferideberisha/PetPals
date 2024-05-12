import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color fillColor; // Add a parameter for fill color
  final Widget? suffixIcon; // Add a parameter for suffix icon

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.fillColor, // Update constructor
    this.suffixIcon, // Initialize suffixIcon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Set the width to match the parent width
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Adjust the radius to make corners rounder
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Adjust the radius to make corners rounder
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: fillColor, // Use the provided fill color
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: suffixIcon, // Use the provided suffix icon
          ),
        ),
      ),
    );
  }
}