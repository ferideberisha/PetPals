import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../components/my_bottom_bar.dart';

class MessageRequestPage extends StatefulWidget {
  @override
  _MessageRequestPageState createState() => _MessageRequestPageState();
}

class _MessageRequestPageState extends State<MessageRequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'Orders',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
        bottom: TabBar(
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: EdgeInsets.zero,
          controller: _tabController,
          labelColor: Color(0xFF604560),
          unselectedLabelColor: Color(0xFF967BB6),
          indicatorColor: Color(0xFF604560),
          tabs: [
            Container(
              padding: EdgeInsets.only(right: 10),
              child: Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Icon(Icons.send, color: Color(0xFF967BB6)),
                    ),
                    SizedBox(width: 6),
                    Text('Outgoing'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 11.0),
              child: Tab(
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
            ),
            Container(
              padding: EdgeInsets.only(right: 11.0),
              child: Tab(
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
            ),
            Container(
              padding: EdgeInsets.only(left: 0),
              child: Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all, color: Color(0xFF967BB6)),
                    SizedBox(width: 8),
                    Text('Completed'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RequestList(status: 'Outgoing'),
          RequestList(status: 'Accepted'),
          RequestList(status: 'Rejected'),
          RequestList(status: 'Completed'),
        ],
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    );
  }
}

class RequestList extends StatelessWidget {
  final String status;

  RequestList({required this.status});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$status Requests'),
    );
  }
}
