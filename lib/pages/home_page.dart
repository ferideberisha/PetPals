import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpals/auth/auth.dart';
import 'package:petpals/service/auth_service.dart'; // Import your AuthService

class HomePage extends StatefulWidget {
  final BuildContext context; // Accept context here

  HomePage({required this.context, super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  // sign user out method
  void signUserOut() {
    AuthService().signOut(); // Call signOut() method from AuthService
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF967BB6),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                //  padding: const EdgeInsets.only(top: 10), // Add padding here
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: AppBar(
                    backgroundColor: Color(0xFF967BB6),
                    actions: [
                      IconButton(
                        onPressed: signUserOut,
                        icon: Icon(Icons.logout),
                      )
                    ],
                    title: InkWell(
                      onTap: () {
                        // Handle search bar tap here
                        // You can navigate to a search page or show a search dialog
                      },
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row( // Align search icon to the left
                          children: [
                            Icon(Icons.search, color: Colors.grey, size: 25,),
                            SizedBox(width: 10),
                            Text('Search...', style: TextStyle(color: Colors.grey,fontSize: 21)),
                            Spacer(),
                          
                              Icon(Icons.tune, color: Colors.grey, size: 25),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
           
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "LOGGED IN AS: " + user.email!,
                          style: TextStyle(fontSize: 20),
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
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomAppBar(
          color: Color(0x7EE6E6FA), // Set the background color here
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(0, Icons.search_outlined),
              buildNavItem(1, Icons.message_outlined),
              buildNavItem(2, Icons.favorite_border_outlined),
              buildNavItem(3, Icons.person_outline),
              buildNavItem(4, Icons.menu),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(int index, IconData iconData) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Add functionality based on the index
      },
      splashColor: Colors.transparent, // Remove splash effect
      highlightColor: Colors.transparent, // Remove highlight effect
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Color(0xFF967BB6) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          size: 30,
          color: _selectedIndex == index ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
