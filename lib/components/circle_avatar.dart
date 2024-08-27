import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircleAvatarWidget extends StatelessWidget {
  final Function(ImageSource) pickImage;
  final dynamic image; // Can be a File or a String URL
  final IconData icon;
  final Function()? onTap;

  const CircleAvatarWidget({
    super.key,
    required this.pickImage,
    this.image,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: image != null
            ? (image is String
                ? image.startsWith('assets/')
                    ? AssetImage(image) as ImageProvider
                    : FileImage(File(image)) as ImageProvider
                : FileImage(image) as ImageProvider)
            : null,
        child: image == null
            ? Icon(
                icon,
                size: 50,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }
}
