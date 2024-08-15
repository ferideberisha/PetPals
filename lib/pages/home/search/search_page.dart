import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/components/user_card.dart';
import 'package:petpals/models/userModel.dart';

class SearchPage extends StatefulWidget {
  final BuildContext context;

  const SearchPage({required this.context, Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final int _selectedIndex = 0;

  TextEditingController _searchController = TextEditingController();
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }

  // void _showSortingOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             const Text(
  //               'Sort By',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 setState(() {
  //                   _filteredUsers.sort((a, b) => a.firstName.compareTo(b.firstName));
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: const Text(
  //                 'Cost low to high',
  //                 style: TextStyle(
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 setState(() {
  //                   _filteredUsers.sort((a, b) => a.lastName.compareTo(b.lastName));
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: const Text(
  //                 'Cost high to low',
  //                 style: TextStyle(
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 // Implement logic for sorting by other criteria
  //                 Navigator.pop(context);
  //               },
  //               child: const Text(
  //                 'Rating high to low',
  //                 style: TextStyle(
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
                    automaticallyImplyLeading: false, // Prevents automatic back button
                  backgroundColor: const Color(0xFF967BB6),
                  leading: null, // Removes the default back button
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
                        // Padding(
                        //   padding: EdgeInsets.all(4), // Adjust padding to create space between the background color and container edges
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Color.fromARGB(108, 174, 174, 211), // Background color for the filter icon
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: IconButton(
                        //       onPressed: _showSortingOptions,
                        //       icon: const Icon(Icons.tune, color: Colors.black, size: 25),
                        //     ),
                        //   ),
                        // ),
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
                                print('Add ${user.firstName} ${user.lastName} to favorites');
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
}}