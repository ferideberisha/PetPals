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
  bool _isLoading = true; // Start with loading state true
  String? _currentUserAddress; // Declare a variable to store the current user's address

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _checkAndShowRoleDialog();
      final users = await fetchUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false; // Set loading state to false after fetching
      });
    } catch (error) {
      print('Error during initialization: $error');
      setState(() {
        _isLoading = false; // Ensure loading state is false in case of error
      });
    }
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

   // Get the current user's address
final currentUserAddress = currentUserSnapshot['address'];
_currentUserAddress = currentUserAddress; // Store the address in the variable

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: oppositeRole)
        .where('address', isEqualTo: currentUserAddress) // Filter by address
        .get();

    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }
void _onSearchChanged(String query) {
  setState(() {
    _filteredUsers = _users.where((user) {
      final name = '${user.firstName} ${user.lastName}'.toLowerCase();
      return name.contains(query.toLowerCase()) &&
          user.address == _currentUserAddress; // Use == for exact address comparison
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
        'address': user.address,
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

  Future<void> _checkAndShowRoleDialog() async {
    try {
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
      }
    } catch (error) {
      print('Error checking user role: $error');
      _showRoleChangeDialog(); // Show dialog if there's an error
    }
  }

  void _showRoleChangeDialog() {
    showDialog(
      context: widget.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Your Role'),
          content: const Text('Please choose your role to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _setUserRole('walker'); // Set role to 'walker'
                Navigator.of(context).pop(); // Close dialog
                _refreshUsers(); // Refresh users after setting the role
              },
              child: const Text('Walker'),
            ),
            TextButton(
              onPressed: () async {
                await _setUserRole('owner'); // Set role to 'owner'
                Navigator.of(context).pop(); // Close dialog
                _refreshUsers(); // Refresh users after setting the role
              },
              child: const Text('Owner'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    try {
      final users = await fetchUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false; // Set loading state to false after refreshing
      });
    } catch (error) {
      print('Error refreshing users: $error');
      setState(() {
        _isLoading = false; // Ensure loading state is false in case of error
      });
    }
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
                        if (_isLoading) // Show loading indicator if fetching
                          const Center(child: CircularProgressIndicator())
                        else if (_filteredUsers.isEmpty)
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
                                    return Container(); // Return an empty container while checking favorited status
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
                          ),
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
