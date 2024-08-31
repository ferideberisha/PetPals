import 'package:flutter/material.dart';
import 'package:petpals/components/pet_card.dart';
import 'package:petpals/controllers/pet_controller.dart';
import 'package:petpals/models/petModel.dart';
import 'package:petpals/pages/home/profile/pets/add_pet_page.dart';
import 'package:petpals/pages/home/profile/pets/edit_pet_page.dart'; // Import EditPetPage

class MyPetsPage extends StatelessWidget {
  final String userId;
  final String role;
  final PetController petController;

  MyPetsPage({super.key, required this.userId, required this.role})
      : petController = PetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddPetPage(userId: userId, role: role),
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: petController.getPetsStreamWithId(userId, role),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final petData = snapshot.data![index];
                final pet = petData['pet'] as Pet;
                final petId = petData['id'] as String;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: PetCard(
                    name: pet.name,
                    gender: pet.gender,
                    size: pet.sizeRange,
                    imageUrl: pet.imagePath,
                    onDelete: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete this pet?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await petController.deletePet(userId, role, petId);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete pet: $e'),
                            ),
                          );
                        }
                      }
                    },
                    // Edit Button Logic
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPetPage(
                            pet: pet,
                            petId: petId,
                            userId: userId,
                            role: role,
                          ),
                        ),
                      );
                    },
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
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.normal),
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
