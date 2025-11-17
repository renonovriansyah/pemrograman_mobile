// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/add_edit_activity_dialog.dart';
import '../widgets/dynamic_stats_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('DAILY ACTIVITY FLOW'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddEditActivityDialog(),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Activity>>(
        stream: activityProvider.activitiesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada aktivitas hari ini.'));
          }

          final activities = snapshot.data!;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Bagian 1: Daily Activity Flow (Contoh Sederhana) ---
                  _buildDailyActivityFlow(activities, activityProvider),
                  const Divider(height: 40),

                  // --- Bagian 2: Current Tasks (List View) ---
                  const Text('CURRENT TASKS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...activities.map((activity) => ActivityCard(activity: activity)),
                  
                  // --- Bagian 3 & 4 (Hanya Placeholder): Dynamic Stats & Notes ---
                  const SizedBox(height: 30),
              const Text('DYNAMIC STATS (Hours Spent)', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Panggil Chart
              DynamicStatsChart(
                  stats: activityProvider.calculateDailyStats(activities)),
                  Container(height: 100, color: Colors.grey.shade200, margin: const EdgeInsets.only(top: 8)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  // Widget untuk simulasi Daily Activity Flow (Horizontal Timeline)
  Widget _buildDailyActivityFlow(List<Activity> activities, ActivityProvider activityProvider) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: activities.map((activity) {
          // Menghitung durasi dalam jam untuk lebar visual (opsional)
          final durationMinutes = activity.endTime.difference(activity.startTime).inMinutes;
          final width = (durationMinutes / 60) * 80 + 50; // Lebar minimum 50px + skala

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: width.clamp(120.0, 250.0), // Batasi lebar
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration( 
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: activity.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.white.withAlpha(2), fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}}