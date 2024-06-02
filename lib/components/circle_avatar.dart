import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CircleAvatarWidget extends StatelessWidget {
  final Function(ImageSource) pickImage;
  final dynamic image; // Can be a File or a String URL
  final IconData icon;
  final Function()? onTap;

  const CircleAvatarWidget({
    Key? key,
    required this.pickImage,
    this.image,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        child: Stack(
          children: [
            if (image != null)
              ClipOval(
                child: image is File
                  ? Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
              ),
            if (image == null)
              Icon(
                icon,
                size: 50,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
