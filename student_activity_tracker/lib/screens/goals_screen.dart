// lib/screens/goals_screen.dart

import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/goal.dart';

class GoalsScreen extends StatelessWidget {
  // GoalsScreen kini menerima 2 List: Activities (untuk hitung progres) dan Goals (untuk tampilkan target)
  final List<Activity> activities; 
  final List<Goal> goals;
  final VoidCallback onNavigateToAddGoal;

  const GoalsScreen({
    super.key,
    required this.activities,
    required this.goals,
    required this.onNavigateToAddGoal,
  });

  // Fungsi Pembantu: Menghitung total jam yang sudah dicatat untuk sebuah kategori
  double _calculateProgressHours(String category) {
    // Di sini, kita simulasikan target per minggu (misalnya, dari awal minggu hingga sekarang)
    // Untuk lebih akurat, Anda perlu memfilter activity berdasarkan rentang tanggal.
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return activities
        .where((a) => a.category == category)
        .where((a) => a.date.isAfter(startOfWeek)) // Filter aktivitas minggu ini
        .fold(0.0, (sum, item) => sum + item.duration);
  }

  // Widget untuk menampilkan kartu Goal
  Widget _buildGoalCard(Goal goal) {
    final achievedHours = _calculateProgressHours(goal.category);
    final progress = achievedHours / goal.targetHours;
    final progressValue = progress.clamp(0.0, 1.0); // Pastikan nilai antara 0.0 dan 1.0
    final isCompleted = achievedHours >= goal.targetHours;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(goal.icon, color: goal.color),
                const SizedBox(width: 8),
                Text(goal.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
            const SizedBox(height: 10),
            
            Text(
              'Target: ${goal.targetHours.toStringAsFixed(1)} hours per week',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade300,
              color: goal.color,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 5),

            Text(
              '${achievedHours.toStringAsFixed(1)} / ${goal.targetHours.toStringAsFixed(1)} hours logged (${(progressValue * 100).toStringAsFixed(0)}%)',
              style: TextStyle(fontSize: 12, color: isCompleted ? Colors.green.shade700 : Colors.blue.shade700, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Goals', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        // Pastikan tidak ada actions di sini
      ),
      body: goals.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Belum ada target yang dibuat. Tambahkan Goal untuk mulai melacak progres mingguanmu!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: goals.map((goal) => _buildGoalCard(goal)).toList(),
            ),
            
      // FLOATING ACTION BUTTON UNTUK GOALS
      floatingActionButton: FloatingActionButton(
          // FUNGSI INI AKAN MEMANGGIL _navigateToAddGoal DARI HOMESCREEN
          onPressed: onNavigateToAddGoal, 
          // Style sama persis dengan Activities
          backgroundColor: Colors.blue,
          shape: const CircleBorder(), 
          child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}