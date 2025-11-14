// lib/screens/activities_screen.dart

import 'package:flutter/material.dart';
import '../models/activity.dart'; // Import Model

class ActivitiesScreen extends StatelessWidget {
  final List<Activity> activities; 
  const ActivitiesScreen({super.key, required this.activities});

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
          // Bar Filter/Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterChip(context, 'All Time', true), // Diubah menjadi All Time
                _buildFilterChip(context, 'Studying', false),
                _buildFilterChip(context, 'Reading', false),
                const Icon(Icons.tune, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Daftar Aktivitas
          Expanded(
            child: activities.isEmpty
              ? const Center(child: Text("Belum ada aktivitas yang dicatat."))
              : ListView.builder(
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

  Widget _buildActivityListItem(Activity activity) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: activity.color.withAlpha(4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(activity.icon, color: activity.color, size: 24),
      ),
      title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text('${activity.category} • ${activity.date.day}/${activity.date.month}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${activity.duration.toStringAsFixed(1)} h',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
          ),
          const Text('logged', style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
      onTap: () {},
    );
  }
}