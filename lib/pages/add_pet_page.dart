import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton

class AddPetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
        
            // Add Pet Form (You can customize this as needed)
            // For example, you can add TextFields for pet name, breed, age, etc.
            // Then handle the form submission accordingly.
            // Here's a sample button for demonstration purposes:
            MyButton(
              onTap: () {
                // Handle Add Pet logic here
                print('Add Pet button tapped!');
              },
              text: 'Add Pet',
              color: Color(0xFF967BB6), // Change the color as needed
              textColor: Colors.white, borderColor: Color(0xFF967BB6), borderWidth: 0,
              
            ),
          ],
        ),
      ),
    );
  }
}
