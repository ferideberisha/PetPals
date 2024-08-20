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
    print("init state is being executed");
    fetchUsers().then((users) {
      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<UserModel>> fetchUsers() async {
    // Print the current user's UID
    print('Current user UID: ${user.uid}');

    // Proceed to fetch the current user's role
    final currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!currentUserSnapshot.exists) {
      print('Current user not found in Firestore.');
      return [];
    }

    final currentUserRole = currentUserSnapshot['role'];
    print('Current user role: $currentUserRole');

    // Determine the opposite role to fetch
    String oppositeRole = currentUserRole == 'walker' ? 'owner' : 'walker';
    print('Fetching users with role: $oppositeRole');

    // Fetch users with the opposite role
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: oppositeRole)
        .get();

    if (snapshot.docs.isEmpty) {
      print('No users found with role: $oppositeRole');
    } else {
      snapshot.docs.forEach((doc) {
        print('Fetched user: ${doc.data()}');
      });
    }

    // Convert the results to a list of UserModel objects
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
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
                              return UserCard(
                                user: user,
                                onFavoriteTap: () {
                                  print(
                                      'Add ${user.firstName} ${user.lastName} to favorites');
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
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}
