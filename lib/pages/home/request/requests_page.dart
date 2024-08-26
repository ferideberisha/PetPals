import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petpals/controllers/booking_controller.dart'; // Import the BookingController
import 'package:petpals/pages/home/request/request_list_page.dart';
import '../../../components/my_bottom_bar.dart';
import 'dart:math' as math;

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedIndex = 1;
  String? currentUserRole;
  final BookingController _bookingController = BookingController(); // Initialize BookingController

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchCurrentUserRole();
  }

  Future<void> fetchCurrentUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final currentUserSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (currentUserSnapshot.exists) {
          setState(() {
            currentUserRole = currentUserSnapshot['role'];
            // Update TabController if needed
          });
        }
      } catch (e) {
        print('Error fetching user role: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final firstTabLabel = currentUserRole == 'walker' ? 'Incoming' : 'Outgoing';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text(
              'Orders',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF604560),
          unselectedLabelColor: const Color(0xFF967BB6),
          indicatorColor: const Color(0xFF604560),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: const Icon(Icons.send, color: Color(0xFF967BB6)),
                  ),
                  const SizedBox(width: 6),
                  Text(firstTabLabel),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Color(0xFF967BB6)),
                  SizedBox(width: 6),
                  Text('Accepted'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.clear, color: Color(0xFF967BB6)),
                  SizedBox(width: 6),
                  Text('Rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
           RequestList(status: firstTabLabel, bookingController: _bookingController, currentUserRole: currentUserRole!),
    RequestList(status: 'Accepted', bookingController: _bookingController, currentUserRole: currentUserRole!),
    RequestList(status: 'Rejected', bookingController: _bookingController, currentUserRole: currentUserRole!),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}
