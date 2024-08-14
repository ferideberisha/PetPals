import 'package:flutter/material.dart';


class PaymentCard extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final bool isDefault;

  const PaymentCard({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.isDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 4.0,
      child: ListTile(
        leading: Icon(
          Icons.credit_card,
          color: isDefault ? Colors.green : Colors.grey,
        ),
        title: Text(
          '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text('Expires on $expiryDate'),
        trailing: isDefault
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : null,
      ),
    );
  }
}