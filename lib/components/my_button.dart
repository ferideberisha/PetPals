import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;
  final Color textColor; // New parameter for text color
  final Color borderColor; // New parameter for border color
  final double borderWidth; // New parameter for border width
  final double? width; // New parameter for button width
  final double? height; // New parameter for button height
  final String? Function(String?)?
      validator; // Keep the validator parameter optional

  // ignore: use_key_in_widget_constructors
  const MyButton({
    Key? key, // Use Key? instead of super.key
    required this.onTap,
    required this.text,
    required this.color,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    this.width, // Make the width parameter optional
    this.height, // Make the height parameter optional
    this.validator, // Make the validator parameter optional
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Set the width if provided, otherwise use double.infinity
      height: height, // Set the height if provided, otherwise use null (auto)
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding here
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
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
