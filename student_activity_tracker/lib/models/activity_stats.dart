// lib/models/activity_stats.dart
import 'package:flutter/material.dart';

class ActivityStats {
  // Nama kategori (misalnya: CALL, DEEPWORK)
  final String title; 
  
  // Durasi dalam jam (digunakan sebagai nilai tinggi batang grafik)
  final double durationHours; 
  
  // Warna untuk batang grafik
  final Color color; 

  ActivityStats({
    required this.title,
    required this.durationHours,
    required this.color,
  });
}