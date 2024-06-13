import 'package:flutter/material.dart';
import 'package:petpals/models/userModel.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailPage extends StatelessWidget {
  final UserModel user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // White background
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          // Background header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 170,
              decoration: const BoxDecoration(
                color: Color(0xFF967BB6),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Back button
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),

                    // Heart icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.white,
                        onPressed: () {
                          // Handle favorite action
                        },
                      ),
                    ),

                    // Title
                    Center(
                      child: Text(
                        'PetPals',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.exo2(
                          textStyle: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Profile section
          Positioned(
            top: 160,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Adding padding around CircleAvatar
                Container(
                  padding: const EdgeInsets.all(4), // Adjust padding as needed
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.profilePicture.isNotEmpty
                          ? user.profilePicture
                          : 'https://via.placeholder.com/150',
                    ),
                    radius: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
