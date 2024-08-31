import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String gender;
  final String size;
  final String? imageUrl; // Change this to imageUrl
  final VoidCallback onDelete; // Callback for delete action
  final VoidCallback onEdit; // Callback for edit action

  const PetCard({
    required this.name,
    required this.gender,
    required this.size,
    this.imageUrl, // Use imageUrl instead of imagePath
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xF5F5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pet Image
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ClipOval(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.pets,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Gender and Size
                  Text(
                    '$gender - Size: $size',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                  ),
                ],
              ),
            ),
            // Edit Button
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromRGBO(97, 97, 97, 1)),
              onPressed: onEdit, // Trigger the edit callback
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFFAF1D1D)),
              onPressed: onDelete, // Trigger the delete callback
            ),
          ],
        ),
      ),
    );
  }
}
