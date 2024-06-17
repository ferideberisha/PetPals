import 'package:flutter/material.dart';
import 'package:petpals/pages/home/profile/profile_page.dart';
import 'package:petpals/pages/home/search/search_page.dart';
import 'package:petpals/pages/home/request/message_request_page.dart';
import 'package:petpals/pages/home/favorite/favorite_page.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = SearchPage(context: context);
        break;
      case 1:
        nextPage = const MessageRequestPage();
        break;
      case 2:
        nextPage = const FavoritePage();
        break;
      case 3:
        nextPage = const ProfilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextPage,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the height of the system's navigation bar
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        color: const Color(0x7EE6E6FA),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(context, 0, Icons.search_outlined),
              buildNavItem(context, 1, Icons.message_outlined),
              buildNavItem(context, 2, Icons.favorite_border_outlined),
              buildNavItem(context, 3, Icons.person_outline),
            ],
          ),
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectedIndex == index
              ? const Color(0xFF967BB6)
              : Colors.transparent,
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
