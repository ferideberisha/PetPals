import 'package:flutter/material.dart';
import 'package:petpals/pages/home_page.dart';
import 'package:petpals/pages/message_request_page.dart';
import 'package:petpals/pages/favorite_page.dart';
import 'package:petpals/pages/profile_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  CustomBottomNavigationBar({required this.selectedIndex});

void _onItemTapped(BuildContext context, int index) {
  if (index == selectedIndex) return;

  Widget nextPage;
  switch (index) {
    case 0:
      nextPage = HomePage(context: context);
      break;
    case 1:
      nextPage = MessageRequestPage();
      break;
    case 2:
      nextPage = FavoritePage();
      break;
    case 3:
      nextPage = ProfilePage(); 
      break;
    case 4:
      nextPage = HomePage(context: context); // Replace with MenuPage
      break;
    default:
      return;
  }

  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => nextPage,
      transitionDuration: Duration.zero,
    ),
    (route) => false,
  );
}


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        color: Color(0x7EE6E6FA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(context, 0, Icons.search_outlined),
            buildNavItem(context, 1, Icons.message_outlined),
            buildNavItem(context, 2, Icons.favorite_border_outlined),
            buildNavItem(context, 3, Icons.person_outline),
            buildNavItem(context, 4, Icons.menu),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(BuildContext context, int index, IconData iconData) {
    return InkWell(
      onTap: () => _onItemTapped(context, index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectedIndex == index ? Color(0xFF967BB6) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          size: 30,
          color: selectedIndex == index ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
