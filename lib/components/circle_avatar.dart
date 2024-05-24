import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircleAvatarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final File? image;
  final Function(ImageSource) pickImage;
  final IconData icon; // New parameter for the icon

  const CircleAvatarWidget({
    super.key,
    required this.onTap,
    required this.image,
    required this.pickImage,
    required this.icon, // Initialize the new parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.grey,
            radius: 60,
            backgroundImage: image != null ? FileImage(image!) : null,
            child: image == null
                ? Icon(icon, size: 80) // Use the icon parameter
                : null,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCAADEE),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
