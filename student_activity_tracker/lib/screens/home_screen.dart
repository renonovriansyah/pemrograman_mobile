// lib/screens/home_screen.dart (KODE FINAL YANG SUDAH DIKOREKSI)

import 'package:flutter/material.dart';
import '../widgets/summary_section.dart'; 
import '../widgets/quick_log_section.dart'; 
import '../widgets/activity_breakdown.dart';
import 'activities_screen.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';

// =========================================================
// === BAGIAN 1: KONTEN STATIS HOME SCREEN (HOME CONTENT) ===
// =========================================================

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Fungsi AppBar yang SEKARANG HANYA AKAN DIGUNAKAN DI SINI
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text('Student Flow', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
      leading: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Color(0xFF42A5F5),
          child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    // ... (Logika Aktivitas Terbaru tetap sama)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFE3F2FD), child: Icon(Icons.menu_book, color: Color(0xFF1976D2), size: 20)),
          title: const Text('Studied Calculus - 9 hours', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('2 hours ago'),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(height: 1),
        ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFBE9E7), child: Icon(Icons.book, color: Color(0xFFE64A19), size: 20)),
          title: const Text('Read "Dune" - 30 minutes', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('4 hours ago'),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // KITA MEMASUKKAN Scaffold DI SINI
    return Scaffold(
      appBar: _buildAppBar(), // Panggil AppBar di sini
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Welcome, Reno!', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                
                const SummarySection(), 
                const SizedBox(height: 30),
                const QuickLogSection(),
                const SizedBox(height: 30),
                const ActivityBreakdown(),
                const SizedBox(height: 30),
                
                _buildRecentActivities(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Floating Action Button
          Positioned(
            bottom: 15, 
            right: 20,
            child: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 10, offset: const Offset(0, 5))]),
              child: IconButton(icon: const Icon(Icons.add, color: Colors.white, size: 30), onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// === BAGIAN 2: CONTROLLER NAVIGASI (HOME SCREEN UTAMA) ===
// =========================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const ActivitiesScreen(),
    const GoalsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // KITA HAPUS SEMUA BARIS YANG BERMASALAH TENTANG AppBar DI SINI
      backgroundColor: Colors.white,

      // Body menampilkan halaman yang dipilih (yang sudah memiliki Scaffold/AppBar masing-masing)
      body: _widgetOptions.elementAt(_selectedIndex), 
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Activities'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}