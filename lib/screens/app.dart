import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sloter/screens/home.dart';
import 'package:sloter/screens/profile_page.dart';

class App extends StatefulWidget {
  final User user;

  const App({ required this.user });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  late User _currentUser;

  int _selectedIndex = 0;

  List<Widget> _pages() => [
    const HomePage(),
    ProfilePage(user: _currentUser),
  ];

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = _pages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sloter'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
