// lib/models/activity.dart

import 'package:flutter/material.dart';

class Activity {
  final String title;
  final double duration; // Durasi dalam jam
  final String category;
  final DateTime date;
  final Color color;
  final IconData icon;

  Activity({
    required this.title,
    required this.duration,
    required this.category,
    required this.date,
    required this.color,
    required this.icon,
  });

  // Fungsi pembantu untuk menentukan warna dan ikon berdasarkan kategori
  static Map<String, dynamic> getCategoryInfo(String category) {
    switch (category) {
      case 'Studying':
        return {'color': const Color(0xFF42A5F5), 'icon': Icons.menu_book};
      case 'Reading':
        return {'color': const Color(0xFFE64A19), 'icon': Icons.book};
      case 'Workout':
        return {'color': const Color(0xFF66BB6A), 'icon': Icons.directions_run};
      case 'Creative':
        return {'color': const Color(0xFF9C27B0), 'icon': Icons.draw};
      default: // Others
        return {'color': Colors.grey, 'icon': Icons.category};
    }
  }
}