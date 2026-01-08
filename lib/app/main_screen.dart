import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweetai/features/recipe/views/fridge_view.dart';
import 'package:sweetai/features/profile/views/profile_view.dart';
import 'package:sweetai/features/authentication/viewmodels/authviewmodel.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0; // 👈 premier onglet au démarrage

  final List<Widget> _pages = const [
    FridgeView(), // index 0 → affiché au lancement
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // le body passe derrière l'appbar
      appBar: _currentIndex == 1
          ? AppBar(
              title: const Text('Profil'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    ref.read(authViewModelProvider).signOut();
                  },
                ),
              ],
            )
          : null,

      body: Stack(
        children: [
          // Fond global qui va aussi sous l'AppBar pour avoir un fond sous l'appbar du profil
          Positioned.fill(
            child: _currentIndex == 0
                ? Image.asset('assets/images/background.jpg', fit: BoxFit.cover)
                : const ColoredBox(color: Color.fromARGB(255, 246, 237, 240)),
          ),
           // Contenu par-dessus
          IndexedStack(index: _currentIndex, children: _pages),
        ],
      ),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
