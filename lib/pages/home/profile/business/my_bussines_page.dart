import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpals/components/my_bottom_bar.dart';
import 'package:petpals/pages/home/profile/business/availability/availability_page.dart';
import 'package:petpals/pages/home/profile/business/prices/prices_page.dart';
import 'package:petpals/pages/home/profile/business/receivedpayments/received_payments_page.dart';

class MyBusinessPage extends StatefulWidget {
  const MyBusinessPage({super.key});

  @override
  State<MyBusinessPage> createState() => _MyBusinessPageState();
}

class _MyBusinessPageState extends State<MyBusinessPage> {
  String? userId;
  String? role;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    // Get the current user ID
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      // Fetch user role from Firestore or wherever you store it
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        role = userDoc.get('role') as String?;
        setState(() {}); // Trigger rebuild
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userId != null && role != null)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PricesPage(
                          userId: userId!,
                          role: role!,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.paid_outlined, color: Colors.black),
                      SizedBox(width: 15),
                      Text(
                        'Prices',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(child: SizedBox()),
                      Icon(Icons.arrow_forward_ios, color: Colors.black),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReceivedPaymentPage()),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.credit_score, color: Colors.black),
                    SizedBox(width: 15),
                    Text(
                      'Received payments',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailabilityPage(
                        userId: userId!,
                        role: role!,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.event_available, color: Colors.black),
                    SizedBox(width: 15),
                    Text(
                      'Availability',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: SizedBox()),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 3),
    );
  }
}
