// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/summary_section.dart'; 
import '../widgets/quick_log_section.dart'; 
import '../widgets/activity_breakdown.dart';
import 'activities_screen.dart';
import 'add_activity_screen.dart';
import 'goals_screen.dart';
import '../models/activity.dart';
import '../models/goal.dart';
import 'add_goal_screen.dart';
import '../models/user.dart';
import 'profile_screen.dart';
// =========================================================
// === BAGIAN 1: KONTEN STATIS HOME SCREEN (HOME CONTENT) ===
// Dibuat Statis untuk kerapihan dan menerima data dinamis
// =========================================================

class HomeContent extends StatelessWidget {
  // Menerima daftar aktivitas
  final List<Activity> activities; 
  const HomeContent({super.key, required this.activities});

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text('Activity Tracker', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
      leading: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Color(0xFF42A5F5),
          child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- Widget Pembantu untuk Aktivitas Terbaru (Menggunakan data dinamis) ---
  Widget _buildRecentActivities() {
    // Ambil 2 aktivitas terbaru saja
    final recent = activities.take(2).toList(); 
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        // Cek jika ada aktivitas
        if (recent.isEmpty)
          const Center(child: Text("No activity has been recorded yet.")),
        
        // Buat ListTile untuk setiap aktivitas
        ...recent.map((activity) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: activity.color.withAlpha(3),
                    child: Icon(activity.icon, color: activity.color, size: 20),
                  ),
                  title: Text('${activity.title} - ${activity.duration.toStringAsFixed(1)} hours', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(activity.date.toString().split(' ')[0]), // Tampilkan tanggal saja
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 1),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  // Fungsi untuk menghitung total jam yang dicatat minggu ini (SIMULASI DATA DINAMIS)
  String _getTotalHours() {
    // Ini hanyalah simulasi perhitungan sederhana
    final total = activities.fold(0.0, (sum, item) => sum + item.duration);
    return total.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Welcome, Reno!', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),

                // 1. Summary/Stats Section (Mengirim data dinamis)
                SummarySection(totalHours: _getTotalHours()), 
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
          // Floating Action Button (Dihapus dari sini, dipindahkan ke Controller)
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

  // DATA DINAMIS DISIMPAN DI SINI
  List<Activity> activities = [];
  List<Goal> goals = [];

  // FUNGSI UNTUK MENAMBAH DATA BARU (CALLBACK)
  void _addActivity(Activity activity) {
    setState(() {
      activities.add(activity);
      activities.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // FUNGSI BARU: MENAMBAH GOAL (CALLBACK)
  void _addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
    });
  }

  // FUNGSI NAVIGASI BARU: PINDAH KE ADD GOAL SCREEN
  void navigateToAddGoal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Meneruskan fungsi _addGoal ke AddGoalScreen
        builder: (context) => AddGoalScreen(onAddGoal: _addGoal), 
      ),
    );
  }

  User _currentUser = User(
    name: 'Reno Mulyadi',
    email: 'reno.mulyadi@student.edu',
    avatarLetter: 'R',
    avatarColor: const Color(0xFF42A5F5), // Biru Muda
  );

  // Fungsi untuk update data user (Callback)
  void updateUser(User updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeContent(activities: activities),      
      ActivitiesScreen(activities: activities), 
      GoalsScreen(activities: activities, goals: goals, onNavigateToAddGoal: () => navigateToAddGoal(context),),
      ProfileScreen(currentUser: _currentUser, onUpdateUser: updateUser, activities: activities,),
    ];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Widget yang dipilih mengisi seluruh layar
          widgetOptions.elementAt(_selectedIndex), 
        ],
      ),
      
      floatingActionButton: _selectedIndex == 1 // HANYA tampilkan jika tab Activities aktif
        ? FloatingActionButton(
            onPressed: () {
              // Aksi yang sama dengan FAB lama
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddActivityScreen(onAddActivity: _addActivity),
                ),
              );
            },
            backgroundColor: Colors.blue,
            shape: const CircleBorder(), // Menggunakan CircleBorder untuk bentuk bulat
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          )
        : null,

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