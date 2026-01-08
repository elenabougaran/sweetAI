import 'package:flutter/material.dart';
import 'package:sweetai/features/recipe/views/fridge_view.dart';
import 'package:sweetai/features/profile/views/profile_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 👈 premier onglet au démarrage

  final List<Widget> _pages = const [
    FridgeView(), // index 0 → affiché au lancement
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Color(0x33000000), // ombre plus visible
        blurRadius: 10,
        offset: Offset(0, -3), // 👈 ombre vers le haut
      ),
    ],
  ),
  child: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
    selectedItemColor: Color(0xFFC26A80),
    unselectedItemColor: Color(0xFFD9B6BF),
    backgroundColor: Color(0xFFFFF4EC),
    elevation: 0, // important : on coupe l'elevation
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Accueil',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profil',
      ),
    ],
  ),
),

    );
  }
}
