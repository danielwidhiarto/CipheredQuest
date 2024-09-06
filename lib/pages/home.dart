import 'package:flutter/material.dart';
import 'package:ciphered_quest/pages/shop.dart';
import 'package:ciphered_quest/pages/quest.dart';
import 'package:ciphered_quest/pages/play.dart';
import 'package:ciphered_quest/pages/friend.dart';
import 'package:ciphered_quest/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Start at Main Page

  static const List<Widget> _pages = <Widget>[
    ShopPage(),
    QuestPage(),
    PlayPage(),
    FriendPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Quest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF776B5D),
        unselectedItemColor: const Color(0xFFB0A695),
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFF3EEEA),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
