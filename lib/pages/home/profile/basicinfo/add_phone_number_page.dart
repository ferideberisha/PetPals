import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:petpals/components/my_button.dart';

class AddPhoneNumberPage extends StatefulWidget {
  @override
  _AddPhoneNumberPageState createState() => _AddPhoneNumberPageState();
}

class _AddPhoneNumberPageState extends State<AddPhoneNumberPage> {
  bool _sendSms = false;
  bool _sendWhatsApp = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPhoneNumberValid = true;

  void _getCode() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle valid phone number
      setState(() {
        _isPhoneNumberValid = true;
      });
    } else {
      setState(() {
        _isPhoneNumberValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add phone number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You need to verify the phone number as it is a means of communication between the walker and the owner:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 10),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  // Handle manual input
                },
                selectorConfig: SelectorConfig(),
                ignoreBlank: true,
                autoValidateMode: AutovalidateMode.onUserInteraction, // Allow manual input without automatic validation
                textFieldController: _phoneNumberController,
                inputDecoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                ),
                selectorTextStyle: TextStyle(color: Colors.black),
                formatInput: true,
                keyboardType: TextInputType.phone,
                inputBorder: OutlineInputBorder(),
                validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please write your number';
  } else {
    // Regular expression to match Kosovo phone numbers starting with 49, 44, 43, or 45 followed by 6 other digits
    final kosovoRegex = RegExp(r'^(49|44|43|45)\d{6}$');
    if (!kosovoRegex.hasMatch(value)) {
      return 'Invalid Kosovo phone number';
    }
  }
  return null;
},

                searchBoxDecoration: InputDecoration(
                  labelText: 'Search country',
                  hintText: 'Search country',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              if (!_isPhoneNumberValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Invalid phone number',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _sendSms,
                    shape: CircleBorder(),
                    onChanged: (value) {
                      setState(() {
                        _sendSms = value ?? false;
                        _sendWhatsApp = false; // Uncheck WhatsApp
                      });
                    },
                  ),
                  Text('Send SMS'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _sendWhatsApp,
                    shape: CircleBorder(),
                    onChanged: (value) {
                      setState(() {
                        _sendWhatsApp = value ?? false;
                        _sendSms = false; // Uncheck SMS
                      });
                    },
                  ),
                  Text('Send to WhatsApp'),
                ],
              ),
              SizedBox(height: 20),
              MyButton(
                onTap: _getCode,
                text: 'Get Code',
                color: Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: Color(0xFF967BB6),
                borderWidth: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}