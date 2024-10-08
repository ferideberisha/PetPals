import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/user_card.dart';
import 'package:petpals/models/userModel.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/search/search_page.dart'; // Import for SearchPage

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late Future<List<UserModel>> _favoritesFuture;
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavorites();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = ColorTween(begin: Colors.grey, end: Colors.red)
        .animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  Future<List<UserModel>> _fetchFavorites() async {
  final List<UserModel> validFavorites = [];
  try {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userId = currentUser.uid;

    final currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    final role = currentUserSnapshot['role'];

    final collectionPath = role == 'walker'
        ? 'users/$userId/walkerInfo/$userId/favorites'
        : 'users/$userId/ownerInfo/$userId/favorites';

    final snapshot = await FirebaseFirestore.instance.collection(collectionPath).get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(data['uid']).get();
if (userDoc.exists) {
  print('Fetched address: ${userDoc['address']}');
}

      if (userDoc.exists) {
        validFavorites.add(UserModel(
  uid: data['uid'],
  firstName: data['firstName'],
  lastName: data['lastName'],
  profilePicture: data['profilePicture'],
  email: data['email'] ?? '',
  role: data['role'] ?? '',
  phoneNumber: data['phoneNumber'] ?? '',
  address: data['address'] ?? '', // Address field is included here
));

      } else {
        // Remove from favorites if the user does not exist
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(data['uid'])
            .delete();
      }
    }

    return validFavorites;
  } catch (e) {
    print('Error fetching favorites: $e');
    return [];
  }
}


  Future<void> _removeFromFavorites(UserModel user) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!currentUserSnapshot.exists) {
        print('User not found.');
        return;
      }

      final currentUserRole = currentUserSnapshot['role'];
      String favoritesPath = currentUserRole == 'walker'
          ? 'users/${currentUser.uid}/walkerInfo/${currentUser.uid}/favorites'
          : 'users/${currentUser.uid}/ownerInfo/${currentUser.uid}/favorites';

      await FirebaseFirestore.instance
          .collection(favoritesPath)
          .doc(user.uid) // Use user.uid for the document ID
          .delete();

      print('User removed from favorites.');
    } catch (e) {
      print('Error removing user from favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Icon(
                        Icons.favorite,
                        size: 60,
                        color: _animation.value,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: MyButton(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(context: context,),
                          ),
                        );
                      },
                      text: 'Search for a sitter',
                      color: Colors.transparent,
                      textColor: const Color(0xFF967BB6),
                      borderColor: const Color(0xFF967BB6),
                      borderWidth: 1.0,
                      width: 390,
                      height: 60,
                    ),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final user = favorites[index];
              return UserCard(
                  elevation: 0, // Remove shadow
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin as needed
                  color: const Color(0x0D967BB6), // Set background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Set border radius
                  ),
                user: user,
                isFavorited: true,
                onFavoriteTap: () {
                  _removeFromFavorites(user);
                  setState(() {
                    _favoritesFuture = _fetchFavorites();
                  });
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
