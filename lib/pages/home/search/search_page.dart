import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/components/user_card.dart';
import 'package:petpals/models/userModel.dart';

class SearchPage extends StatefulWidget {
  final BuildContext context;

  const SearchPage({required this.context, super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final int _selectedIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers().then((users) {
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    });
      _checkAndShowRoleDialog(); // Check role and show dialog if needed
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<UserModel>> fetchUsers() async {
    final currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!currentUserSnapshot.exists) {
      return [];
    }

    final currentUserRole = currentUserSnapshot['role'];
    String oppositeRole = currentUserRole == 'walker' ? 'owner' : 'walker';

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: oppositeRole)
        .get();

    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final name = '${user.firstName} ${user.lastName}'.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

Future<void> _addToFavorites(UserModel user) async {
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
        .set({
      'uid': user.uid,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'role': user.role,
      'profilePicture': user.profilePicture,
    });

    print('User added to favorites.');
  } catch (e) {
    print('Error adding user to favorites: $e');
  }
}
Future<bool> _isUserFavorited(UserModel user) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final currentUserSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .get();
  final currentUserRole = currentUserSnapshot['role'];
  String favoritesPath = currentUserRole == 'walker'
      ? 'users/${currentUser.uid}/walkerInfo/${currentUser.uid}/favorites'
      : 'users/${currentUser.uid}/ownerInfo/${currentUser.uid}/favorites';

  final docSnapshot = await FirebaseFirestore.instance
      .collection(favoritesPath)
      .doc(user.uid)
      .get();
  
  return docSnapshot.exists;
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

void _checkAndShowRoleDialog() async {
  final currentUserSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  if (!currentUserSnapshot.exists) {
    _showRoleChangeDialog(); // Show dialog if user data does not exist
    return;
  }

  final currentUserRole = currentUserSnapshot['role'];
  if (currentUserRole == null || currentUserRole.isEmpty) {
    _showRoleChangeDialog(); // Show dialog if user role is not set
  } else {
    fetchUsers().then((users) {
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    });
  }
}

void _showRoleChangeDialog() {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Set Your Role'),
        content: const Text('Please choose your role to continue.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _setUserRole('walker'); // Set role to 'walker'
              Navigator.of(context).pop(); // Close dialog
              fetchUsers().then((users) {
                setState(() {
                  _users = users;
                  _filteredUsers = users;
                });
              });
            },
            child: const Text('Walker'),
          ),
          TextButton(
            onPressed: () {
              _setUserRole('owner'); // Set role to 'owner'
              Navigator.of(context).pop(); // Close dialog
              fetchUsers().then((users) {
                setState(() {
                  _users = users;
                  _filteredUsers = users;
                });
              });
            },
            child: const Text('Owner'),
          ),
        ],
      );
    },
  );
}

Future<void> _setUserRole(String role) async {
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
    {'role': role},
    SetOptions(merge: true), // Merge with existing data
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF967BB6),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(0xFF967BB6),
                    leading: null,
                    title: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                decoration: const InputDecoration(
                                  hintText: 'Search...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        if (_filteredUsers.isEmpty)
                          const Text('No users found')
                        else
                          ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: _filteredUsers.length,
  itemBuilder: (context, index) {
    final user = _filteredUsers[index];
    return FutureBuilder<bool>(
      future: _isUserFavorited(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Error fetching favorite status'));
        }

        final isFavorited = snapshot.data!;

        return UserCard(
          user: user,
          isFavorited: isFavorited,
          onFavoriteTap: () {
            if (isFavorited) {
              _removeFromFavorites(user);
            } else {
              _addToFavorites(user);
            }
            setState(() {});
          },
        );
      },
    );
  },
)

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}
