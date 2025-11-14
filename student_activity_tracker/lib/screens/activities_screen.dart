// lib/screens/activities_screen.dart

import 'package:flutter/material.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  // Data dummy untuk daftar aktivitas (serupa dengan data di Home Screen)
  final List<Map<String, dynamic>> activities = const [
    {'category': 'Studying', 'title': 'Studied Calculus', 'duration': '9.0 h', 'date': 'Today', 'color': Color(0xFF42A5F5), 'icon': Icons.menu_book}, // Biru
    {'category': 'Reading', 'title': 'Read "Dune"', 'duration': '0.5 h', 'date': 'Today', 'color': Color(0xFFE64A19), 'icon': Icons.book}, // Oranye Tua
    {'category': 'Workout', 'title': 'Gym Session', 'duration': '1.0 h', 'date': 'Yesterday', 'color': Color(0xFF66BB6A), 'icon': Icons.directions_run}, // Hijau
    {'category': 'Creative', 'title': 'Finished Sketch', 'duration': '1.5 h', 'date': 'Yesterday', 'color': Color(0xFF9C27B0), 'icon': Icons.draw}, // Ungu
    {'category': 'Studying', 'title': 'Prepared Physics', 'duration': '3.0 h', 'date': 'Mon, 13/11', 'color': Color(0xFF42A5F5), 'icon': Icons.menu_book},
    {'category': 'Reading', 'title': 'Journal Article', 'duration': '0.7 h', 'date': 'Mon, 13/11', 'color': Color(0xFFE64A19), 'icon': Icons.book},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities Log', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bar Filter/Sort (Sinkron dengan gaya modern)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterChip(context, 'Today', true),
                _buildFilterChip(context, 'Last 7 Days', false),
                _buildFilterChip(context, 'Studying', false),
                const Icon(Icons.tune, color: Colors.grey), // Icon filter tambahan
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Daftar Aktivitas
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityListItem(activity);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Pembantu untuk Chip Filter (Gaya seragam)
  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
    );
  }

  // Widget Pembantu untuk Setiap Item Daftar (Gaya seragam dengan Home Screen)
  Widget _buildActivityListItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activity['color'].withOpacity(0.15), // Latar belakang transparan
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(activity['icon'] as IconData, color: activity['color'], size: 24),
      ),
      title: Text(activity['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text('${activity['category']} • ${activity['date']}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            activity['duration'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
          ),
          const Text('logged', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
      onTap: () {
        // Fungsionalitas: Menampilkan detail aktivitas
      },
    );
  }
}