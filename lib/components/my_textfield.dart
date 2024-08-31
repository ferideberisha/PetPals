import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color fillColor;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon; // Add prefixIcon property
  final TextInputType? keyboardType; // Optional parameter for keyboard type
  final List<TextInputFormatter>? inputFormatters; // Optional parameter for input formatters

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.fillColor,
    this.validator,
    this.onTap,
    this.suffixIcon,
    this.readOnly = false,
    this.prefixIcon,
    this.keyboardType, // Initialize keyboardType
    this.inputFormatters, // Initialize inputFormatters
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType, // Pass keyboardType
          inputFormatters: widget.inputFormatters, // Pass inputFormatters
          decoration: InputDecoration(
            labelText: widget.hintText,
            labelStyle: TextStyle(color: Colors.grey[500]),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromRGBO(226, 225, 225, 1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF967BB6)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            fillColor: widget.fillColor,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[300]),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
