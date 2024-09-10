import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';

class ReceivedPaymentPage extends StatefulWidget {
  const ReceivedPaymentPage({super.key});

  @override
  State<ReceivedPaymentPage> createState() => _ReceivedPaymentPageState();
}

class _ReceivedPaymentPageState extends State<ReceivedPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCAADEE)),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'PetPals uses Paypal, one of the most popular payment platforms to transfer your earnings to your bank account. '
                    'You need to create a Paypal account to receive and send payments. To continue, use the button below.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: MyButton(
                      onTap: () {
                        // Handle button press
                      },
                      text: 'Connect PayPal',
                      color: const Color(0xFF967BB6),
                      textColor: Colors.white,
                      borderColor: const Color(0xFF967BB6),
                      borderWidth: 1.0,
                      width: 390,
                      height: 60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}