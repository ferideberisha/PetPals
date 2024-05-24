import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart'; // Import MyButton
import 'package:petpals/pages/home/profile/pets/add_pet_page.dart'; // Import the AddPetPage

class MyPetsPage extends StatelessWidget {
  const MyPetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets',
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
              'lib/images/dog.png', // Path to the dog image
              height: 150,
              width: 150,
            ),

            // Title
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  'You have no pets in your list yet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            // Add Pet button
            MyButton(
              onTap: () {
                // Navigate to the AddPetPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPetPage()),
                );
              },
              text: 'Add Pet',
              color: const Color(0xFF967BB6), // Change the color as needed
              textColor: Colors.white, borderColor: const Color(0xFF967BB6),
              borderWidth: 0,
            ),
          ],
        ),
      ),
    );
  }
}
