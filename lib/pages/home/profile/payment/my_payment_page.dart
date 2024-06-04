import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/profile/payment/add_payment_page.dart'; // Import MyButton

class MyPaymentsPage extends StatelessWidget {
  const MyPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Dog
            Image.asset(
              'lib/images/cards.png', // Path to the dog image
              height: 150,
              width: 150,
            ),

            // Title
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  'You have no payment methods in your list yet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            // Add Pet button
            MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPaymentPage()),
                );
              },
              text: 'Add payment method',
              color: const Color(0xFF967BB6), // Change the color as needed
              textColor: Colors.white, borderColor: const Color(0xFF967BB6),
              borderWidth: 0,
              width: 390,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
