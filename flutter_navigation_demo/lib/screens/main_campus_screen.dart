import 'package:flutter/material.dart';
import 'navigation_menu_screen.dart';
import 'campus_info_screen.dart';
import 'profile_screen.dart';

class MainCampusScreen extends StatefulWidget {
  const MainCampusScreen({super.key});

  @override
  State<MainCampusScreen> createState() => _MainCampusScreenState();
}

class _MainCampusScreenState extends State<MainCampusScreen> {
  int _selectedIndex = 0;

  // Daftar Halaman untuk Bottom Navigation Bar
  final List<Widget> _widgetOptions = <Widget>[
    const NavigationMenuScreen(), // Index 0: Home/Landing Page
    const CampusInfoScreen(),      // Index 1: Info Kampus (Kini dengan Tab Bar)
    const ProfileScreen(),         // Index 2: Profil Mahasiswa
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PERUBAHAN UTAMA: Hapus AppBar dan Drawer di sini ---
      // AppBar dan Drawer akan diimplementasikan secara individual di NavigationMenuScreen dan ProfileScreen
      // (atau di dalam CampusInfoScreen untuk TabBar)

      // Menggunakan IndexedStack untuk mempertahankan state dari setiap tab.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ), 
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}