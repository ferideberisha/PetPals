import 'package:flutter/material.dart';
import 'package:petpals/components/pet_card.dart';
import 'package:petpals/models/petModel.dart';
import 'package:petpals/service/firestore_service.dart';
import 'package:petpals/pages/home/profile/pets/add_pet_page.dart'; // Adjust import as per your project structure

class MyPetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16.0), // Adjust the right padding as needed
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPetPage()),
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
      body: StreamBuilder<List<Pet>>(
        stream: FirestoreService().getPetsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pet = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PetCard(
                    name: pet.name,
                    gender: pet.gender,
                    size: pet.sizeRange,
                    imagePath: pet.imagePath, // Adjust imagePath as per your model
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
                    'lib/images/dog.png',
                    height: 150,
                    width: 150,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 40),
                    child: Text(
                      'You have no pets in your list yet',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    ),
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
