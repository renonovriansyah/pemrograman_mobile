// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // --- 1. Header Profil ---
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // --- 2. Statistik Ringkasan (Sinkron dengan Home Screen) ---
            _buildStatsRow(),
            const SizedBox(height: 40),

            // --- 3. Menu Pengaturan ---
            _buildSettingsSection(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu: Header Profil
  Widget _buildProfileHeader() {
    return Column(
      children: const [
        CircleAvatar(
          radius: 60,
          backgroundColor: Color(0xFF42A5F5), // Biru Muda
          child: Text(
            'R',
            style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'M. Reno Novriansyah',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '701230016@student.uinjambi.ac.id',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Widget Pembantu: Statistik Ringkasan
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total Log', '125', Colors.blue),
        _buildStatItem('Average', '2.5 hrs/day', Colors.green),
        _buildStatItem('Best Streak', '14 Days', Colors.orange),
      ],
    );
  }

  // Widget Pembantu: Item Statistik Individual
  Widget _buildStatItem(String title, String value, Color color) {
    return Container(
      width: 100, // Lebar tetap untuk kerapihan
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget Pembantu: Menu Pengaturan
  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const Divider(),

        _buildSettingTile(Icons.notifications_none, 'Notifications', () {}),
        _buildSettingTile(Icons.palette_outlined, 'Appearance (Theme)', () {}),
        _buildSettingTile(Icons.lock_outline, 'Privacy & Security', () {}),
        _buildSettingTile(Icons.help_outline, 'Help & Support', () {}),
        
        const SizedBox(height: 20),
        
        // Logout Button
        _buildSettingTile(Icons.logout, 'Logout', () {
          // Logika logout di sini
        }, color: Colors.red),
      ],
    );
  }

  // Widget Pembantu: Item Menu Pengaturan
  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue, size: 28),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color ?? Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}