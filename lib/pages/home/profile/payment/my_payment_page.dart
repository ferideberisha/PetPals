import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/controllers/payment_controller.dart';
import 'package:petpals/models/paymentModel.dart';
import 'package:petpals/components/payment_card.dart'; // Import the PaymentCard widget
import 'package:petpals/pages/home/profile/payment/add_payment_page.dart';

class MyPaymentsPage extends StatelessWidget {
  final String userId;
  final String role;
  final PaymentController paymentController;

  MyPaymentsPage({required this.userId, required this.role})
      : paymentController = PaymentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPaymentPage(userId: userId, role: role),
                  ),
                );
              },
              child: const Text(
                '+ Add',
                style: TextStyle(
                  color: Color(0xFF967BB6),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Payment>>(
        stream: paymentController.getPaymentsStream(userId, role),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final payment = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PaymentCard(
                    cardNumber: payment.cardNumber,
                    expiryDate: payment.expiryDate,
                    isDefault: payment.isDefault,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/cards.png',
                    height: 150,
                    width: 150,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 40),
                    child: Text(
                      'You have no payment methods in your list yet',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    ),
                  ),
                  MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPaymentPage(userId: userId, role: role)),
                      );
                    },
                    text: 'Add payment method',
                    color: const Color(0xFF967BB6),
                    textColor: Colors.white,
                    borderColor: const Color(0xFF967BB6),
                    borderWidth: 0,
                    width: 390,
                    height: 60,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
