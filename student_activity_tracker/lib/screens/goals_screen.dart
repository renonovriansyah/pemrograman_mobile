// lib/screens/goals_screen.dart

import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  // Data dummy untuk Weekly Goals
  final List<Map<String, dynamic>> weeklyGoals = const [
    {'title': 'Study Calculus', 'target': 10.0, 'progress': 7.5, 'unit': 'hours', 'color': Color(0xFF42A5F5)},
    {'title': 'Read Literature', 'target': 3.0, 'progress': 3.0, 'unit': 'books', 'color': Color(0xFF66BB6A)},
  ];

  // Data dummy untuk Monthly Goals
  final List<Map<String, dynamic>> monthlyGoals = const [
    {'title': 'Finish Project', 'target': 1.0, 'progress': 0.8, 'unit': 'project', 'color': Color(0xFFFF7043)},
    {'title': 'Workout Sessions', 'target': 12.0, 'progress': 5.0, 'unit': 'times', 'color': Color(0xFF9C27B0)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Goals', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Weekly Goals Section ---
            _buildGoalSectionTitle('Weekly Goals'),
            const SizedBox(height: 10),
            ...weeklyGoals.map((goal) => _buildGoalCard(goal)),
            
            const SizedBox(height: 30),

            // --- Monthly Goals Section ---
            _buildGoalSectionTitle('Monthly Goals'),
            const SizedBox(height: 10),
            ...monthlyGoals.map((goal) => _buildGoalCard(goal)),

            const SizedBox(height: 50),
            
            // --- Add New Goal Button ---
            Center(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                label: const Text('Add New Goal', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: Colors.blue, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Judul Bagian
  Widget _buildGoalSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // Widget Pembantu untuk Kartu Goal (Sinkron dengan gaya Card Home Screen)
  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final double target = goal['target'];
    final double progress = goal['progress'];
    final double percentage = progress / target;
    final Color color = goal['color'];
    final bool isCompleted = progress >= target;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  goal['title'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withAlpha(3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${((percentage * 100)).toStringAsFixed(0)}%',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 8),

            // Target vs Progress
            Text(
              '${progress.toStringAsFixed(1)} / ${target.toStringAsFixed(1)} ${goal['unit']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),

            // Progress Bar
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}