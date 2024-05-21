import 'package:flutter/material.dart';
import 'package:petpals/pages/add_phone_number_page.dart'; // Import the AddPhoneNumberPage

class MyPhoneNumberButton extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  const MyPhoneNumberButton({
    Key? key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: InkWell(
          onTap: enabled ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPhoneNumberPage()),
            );
          } : null,
          child: TextFormField(
            controller: controller,
            readOnly: true,
            onTap: enabled ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPhoneNumberPage()),
              );
            } : null,
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: TextStyle(color: Colors.grey[500]), // Hint text color
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color.fromRGBO(226, 225, 225, 1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF967BB6)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red),
              ),
              fillColor: Colors.white,
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[300]),
              suffixIcon: enabled ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPhoneNumberPage()),
                  );
                },
                child: Icon(Icons.arrow_circle_right_outlined),
              ) : null,
            ),
          ),
        ),
      ),
    );
  }
}
