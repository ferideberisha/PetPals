import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String userImageURL;
  final VoidCallback onFavoriteTap;

  const UserCard({
    Key? key,
    required this.userName,
    required this.userImageURL,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white, // Set the card background color to white
      child: Container(
        height: 120, // Increase the height here if needed
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userImageURL),
              radius: 40, // Adjust the radius if needed
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0), // Adjust bottom padding to move the name up
                    child: Text(
                      userName,
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
    );
  }
}
