// lib/models/goal.dart

import 'package:flutter/material.dart';

class Goal {
  final String title;
  final String category;
  final double targetHours; // Target jam per minggu (atau periode tertentu)
  final Color color;
  final IconData icon;

  Goal({
    required this.title,
    required this.category,
    required this.targetHours,
    required this.color,
    required this.icon,
  });
}