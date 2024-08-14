import 'package:flutter/material.dart';
import 'package:petpals/components/pet_card.dart';
import 'package:petpals/controllers/pet_controller.dart';
import 'package:petpals/models/petModel.dart';
import 'package:petpals/pages/home/profile/pets/add_pet_page.dart'; // Adjust import as per your project structure

class MyPetsPage extends StatelessWidget {
  final String userId;
  final String role;
  final PetController petController;

  MyPetsPage({required this.userId, required this.role})
      : petController = PetController();

  @override
  Widget build(BuildContext context) {
    print('MyPetsPage - userId: $userId, role: $role');

    if (userId.isEmpty || role.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Pets', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Text(
            'Invalid userId or role',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPetPage(userId: userId, role: role),
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
         body: StreamBuilder<List<Pet>>(
        stream: petController.getPetsStream(userId, role),
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