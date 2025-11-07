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

  final List<Widget> _widgetOptions = <Widget>[
    const NavigationMenuScreen(), // Index 0: Home/Landing Page
    const CampusInfoScreen(),      // Index 1: Info Kampus
    const ProfileScreen(),         // Index 2: Profil Mahasiswa
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // Widget Drawer Navigation (Menu Tambahan Kampus)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, size: 40, color: Color(0xFF001F3F)),
                ),
                SizedBox(height: 10),
                Text(
                  'Portal Menu Akademik',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Akses Peta Kampus (/map)'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              Navigator.pushNamed(context, '/map', arguments: 'Akses dari Drawer');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('Profil Mahasiswa'),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
              _onItemTapped(2); // Pindah ke tab Profil
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Log Out'),
            onTap: () {
              // Aksi Keluar - Bisa menggunakan Push Replacement ke Login Screen
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hilangkan AppBar di halaman Home/Landing Page (Index 0)
    final bool showAppBar = _selectedIndex != 0;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(_selectedIndex == 1 ? 'Info Kampus' : 'Profil Mahasiswa'),
            )
          : null,
      
      // Drawer hanya muncul di Info dan Profil
      drawer: showAppBar ? _buildDrawer(context) : null,
      
      body: _widgetOptions.elementAt(_selectedIndex), 
      
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