import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/pages/home/search/user_detail_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onFavoriteTap;
  final bool isFavorited; // Add this property

  const UserCard({
    Key? key,
    required this.user,
    required this.onFavoriteTap,
    this.isFavorited = false, // Initialize to false by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailPage(user: user),
            ),
          );
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
    if (profilePicture.isEmpty) {
      return null; // Placeholder icon is used if there's no profile picture
    } else if (_isNetworkUrl(profilePicture)) {
      return NetworkImage(profilePicture);
    } else {
      return FileImage(File(profilePicture)) as ImageProvider;
    }
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }
}
