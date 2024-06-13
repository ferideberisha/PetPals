import 'dart:io';

import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String gender;
  final String size;
  final String? imagePath; // Make imagePath nullable in case no image is provided

  const PetCard({
    required this.name,
    required this.gender,
    required this.size,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Color(0xF5F5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pet Image
            Padding(
              padding: const EdgeInsets.only(right: 16.0), // Adjust as needed
              child: ClipOval(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: imagePath != null
                      ? Image.file(
                          File(imagePath!), // Assuming imagePath is a file path
                          fit: BoxFit.cover,
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.pets,
                            color: Colors.white,
                          ),
                        ), // Circle avatar with paw icon when no image is available
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
          ],
        ),
      ),
    );
  }
}
