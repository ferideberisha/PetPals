import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/components/my_textfield.dart'; // Import the new date picker

class AddPaymentPage extends StatefulWidget {
  @override
  _AddPaymentPageState createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  bool isDefault = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Number TextField
            MyTextField(
              controller: cardNumberController,
              hintText: 'Card Number',
              obscureText: false,
              fillColor: Colors.white,
            ),
            SizedBox(height: 5),
            Text('Enter the 16-digit card number', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            // Expiry Date and CVV2 Row
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextFormField(
                      controller: expiryDateController,
                      decoration: InputDecoration(
                        hintText: 'Expiry Date',
                        labelText: 'Expiry Date', // Add labelText for consistent styling
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
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(7), // Limit to MM/yyyy format
                        ExpiryDateInputFormatter(), // Custom input formatter
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the expiry date';
                        }
                        if (!RegExp(r'^(0[1-9]|1[0-2])\/20[2-9]\d$').hasMatch(value)) {
                          return 'Invalid expiry date. Please use MM/yyyy format.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MyTextField(
                    controller: cvvController,
                    hintText: 'CVV2',
                    obscureText: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Set as Default option
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set as Default',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                Switch(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Submit Button
            MyButton(
              onTap: () {
                // Add your logic to handle form submission
              },
              text: 'Submit',
              color: Color(0xFF967BB6), // Change the color as needed
              textColor: Colors.white,
              borderColor: Color(0xFF967BB6),
              borderWidth: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    if (newText.length == 2 && !newText.contains('/')) {
      return newValue.copyWith(
        text: '$newText/',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    return newValue;
  }
}
