import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/components/my_textfield.dart';
import 'package:petpals/controllers/payment_controller.dart';
import 'package:petpals/models/paymentModel.dart';

class AddPaymentPage extends StatefulWidget {
  final String userId;
  final String role;

  const AddPaymentPage({super.key, required this.userId, required this.role});

  @override
  _AddPaymentPageState createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  bool isDefault = false;
  final PaymentController _paymentController = PaymentController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

Future<void> savePaymentToFirestore(Payment payment) async {
  try {
    // Log path and payment data
    print('Saving payment: ${payment.toMap()} to Firestore');
    await _paymentController.addPayment(payment, widget.userId, widget.role);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment method added successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add payment method: $e')),
    );
  }

  // Clear form fields after successful submission
  setState(() {
    cardNumberController.clear();
    cvvController.clear();
    expiryDateController.clear();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyTextField(
                controller: cardNumberController,
                hintText: 'Card Number',
                obscureText: false,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  // Remove any spaces from the card number
                  final cleanedValue = value.replaceAll(RegExp(r'\s+'), '');
                  if (cleanedValue.length != 16) {
                    return 'Invalid card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
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
                          labelText: 'Expiry Date',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(226, 225, 225, 1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFF967BB6)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          ExpiryDateInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the expiry date';
                          }
                          if (!RegExp(r'^(0[1-9]|1[0-2])\/20[2-9]\d$')
                              .hasMatch(value)) {
                            return 'Invalid expiry date. Please use MM/yyyy format.';
                          }
                          final parts = value.split('/');
                          final month = int.parse(parts[0]);
                          final year = int.parse(parts[1]);
                          final currentYear = DateTime.now().year;
                          final maxYear = currentYear + 5;
                          if (year > maxYear ||
                              (year == maxYear && month > 12)) {
                            return 'Year cannot be more than \n$maxYear';
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the CVV2';
                        }
                        if (value.length != 3) {
                          return 'CVV2 must be 3 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Set as Default',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
              const SizedBox(height: 20),
              MyButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                  
                      final payment = Payment(
                        cardNumber: cardNumberController.text,
                        expiryDate: expiryDateController.text,
                        cvv: cvvController.text,
                        isDefault: isDefault,
                      );

                      savePaymentToFirestore(payment);
                    }
                  
                },
                text: 'Submit',
                color: const Color(0xFF967BB6),
                textColor: Colors.white,
                borderColor: const Color(0xFF967BB6),
                borderWidth: 0,
                width: 390,
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
