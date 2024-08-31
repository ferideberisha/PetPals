import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/pages/home/search/owner_detail_page.dart';
import 'package:petpals/pages/home/search/walker_detail_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onFavoriteTap;
  final bool isFavorited;
  final double elevation; // Optional parameter for card elevation
  final EdgeInsetsGeometry margin; // Optional parameter for card margin
  final Color color; // Optional parameter for card background color
  final ShapeBorder shape; // Optional parameter for card shape

  const UserCard({
    Key? key,
    required this.user,
    required this.onFavoriteTap,
    this.isFavorited = false,
    this.elevation = 0.0, // Default value for elevation
    this.margin = const EdgeInsets.all(10), // Default value for margin
    this.color = Colors.white, // Default value for color
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)), // Default shape with border radius
    ), // Default value for shape
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: margin,
      color: color,
      shape: shape,
      child: InkWell(
        onTap: () {
          // Navigate to the appropriate detail page based on the user's role
          if (user.role == 'walker') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalkerDetailPage(user: user),
              ),
            );
          } else if (user.role == 'owner') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OwnerDetailPage(user: user), // Navigate to OwnerDetailPage
              ),
            );
          }
        },
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: _getProfileImage(user.profilePicture),
                backgroundColor: user.profilePicture.isEmpty ? Colors.grey.shade200 : null,
                radius: 40,
                child: user.profilePicture.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Color.fromRGBO(158, 158, 158, 1))
                    : null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Additional details can be added here if needed
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : null, // Set color if favorited
                ),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage(String profilePicture) {
    try {
      if (profilePicture.isEmpty) {
        return null; // Placeholder icon if no profile picture
      } else if (_isNetworkUrl(profilePicture)) {
        return NetworkImage(profilePicture);
      } else {
        final file = File(profilePicture);
        if (file.existsSync()) {
          return FileImage(file);
        } else {
          print('File does not exist: $profilePicture');
          return null;
        }
      }
    } catch (e) {
      print('Error loading profile picture: $e');
      return null;
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }
}
