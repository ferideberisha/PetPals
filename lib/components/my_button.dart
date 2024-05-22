import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;
  final Color textColor; // New parameter for text color
  final Color borderColor; // New parameter for border color
  final double borderWidth; // New parameter for border width

  const MyButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.textColor, // Define the new parameter
    required this.borderColor, // Define the new parameter
    required this.borderWidth, // Define the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Set the width to match the parent width
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: color, // Use the provided color for the background
            border: Border.all(
              color: borderColor, // Use the provided border color
              width: borderWidth, // Use the provided border width
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor, // Use the provided text color
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
