import 'package:flutter/material.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/pages/home/search/user_detail_page.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onFavoriteTap;

  const UserCard({
    Key? key,
    required this.user,
    required this.onFavoriteTap,
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
                backgroundImage: NetworkImage(user.profilePicture.isNotEmpty
                    ? user.profilePicture
                    : 'https://via.placeholder.com/150'),
                radius: 40,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
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
                icon: const Icon(Icons.favorite_border),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
