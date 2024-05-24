import 'package:flutter/material.dart';
import 'package:petpals/components/my_button.dart';
import 'package:petpals/pages/home/home_page.dart';
import '../../../components/my_bottom_bar.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = ColorTween(begin: Colors.grey, end: Colors.red)
        .animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Icon(
                  Icons.favorite,
                  size: 60,
                  color: _animation.value,
                );
              },
            ),
            SizedBox(height: 10),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Container(
              width: 350,
              height: 60,
              child: MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(context: context)),
                  );
                },
                text: 'Search for a sitter',
                color: Colors.transparent,
                textColor: Color(0xFF967BB6),
                borderColor: Color(0xFF967BB6),
                borderWidth: 1.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}