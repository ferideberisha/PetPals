import 'package:flutter/material.dart';
import 'package:petpals/pages/home/profile/basicinfo/add_phone_number_page.dart'; // Import the AddPhoneNumberPage

class MyPhoneNumberButton extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  const MyPhoneNumberButton({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyPhoneNumberButtonState createState() => _MyPhoneNumberButtonState();
}

class _MyPhoneNumberButtonState extends State<MyPhoneNumberButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: TextFormField(
            controller: widget.controller,
            readOnly: true,
            onTap: widget.enabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPhoneNumberPage()),
                    );
                  }
                : null,
            decoration: InputDecoration(
              labelText: widget.hintText,
              labelStyle: TextStyle(color: Colors.grey[500]), // Hint text color
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color.fromRGBO(226, 225, 225, 1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color:
                      _isHovered ? const Color(0xFF967BB6) : Colors.grey[400]!,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              fillColor: Colors.white,
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[300]),
              suffixIcon: widget.enabled
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddPhoneNumberPage()),
                        );
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              // Add additional validation rules here
              return null;
            },
          ),
        ),
      ),
    );
  }
}
