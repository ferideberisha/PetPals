import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircleAvatarWidget extends StatelessWidget {
  final Function(ImageSource) pickImage;
  final dynamic image; // Can be a File, String URL, or NetworkImage
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
        backgroundImage: _getBackgroundImage(),
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

  ImageProvider<Object>? _getBackgroundImage() {
    if (image == null) return null;

    if (image is String) {
      if (image.startsWith('http')) {
        return NetworkImage(image) as ImageProvider<Object>;
      } else if (image.startsWith('assets/')) {
        return AssetImage(image) as ImageProvider<Object>;
      } else {
        return FileImage(File(image)) as ImageProvider<Object>;
      }
    } else if (image is File) {
      return FileImage(image) as ImageProvider<Object>;
    } else if (image is NetworkImage) {
      return image;
    }

    return null;
  }
}
