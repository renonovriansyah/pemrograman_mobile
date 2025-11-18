import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Tambah
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Tambah

import '../models/activity.dart';
import '../models/habit.dart';
import '../providers/activity_provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/add_edit_activity_dialog.dart';
import '../widgets/habit_card.dart';
import '../widgets/add_edit_habit_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Providers
    final activityProvider = Provider.of<ActivityProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);

    // Kueri utama
    return StreamBuilder<List<Activity>>(
      stream: activityProvider.activitiesStream,
      builder: (context, activitySnapshot) {
        if (activitySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final activities = activitySnapshot.data ?? [];

        return StreamBuilder<List<Habit>>(
          stream: habitProvider.habitsStream,
          builder: (context, habitSnapshot) {
            final habits = habitSnapshot.data ?? [];

            // Tata letak utama menggunakan Row untuk layout 3 kolom (asumsi layar lebar)
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Kolom Kiri: Stats & Input Cepat
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, activities),
                        const SizedBox(height: 16),
                        _buildQuickInputCard(context),
                        const SizedBox(height: 16),
                        _buildStaticStats(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 2. Kolom Tengah: Time Blocking (Timeline Aktivitas)
                  Expanded(
                    flex: 3,
                    child: _buildTimeBlocking(activities, activityProvider),
                  ),
                  const SizedBox(width: 16),

                  // 3. Kolom Kanan: Tasks & Habits
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUrgentTasks(context, activities),
                        const SizedBox(height: 16),
                        _buildHabitTracker(context, habits),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- WIDGET PEMBANGUNAN ---

  // Header dan Progress Circle
  Widget _buildHeader(BuildContext context, List<Activity> activities) {
    int totalTasks = activities.length;
    int completedTasks = activities.where((a) => a.isCompleted).length;
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    String date = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hari ini: $date', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: progress,
                  center: Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.teal),
                  ),
                  progressColor: Colors.teal,
                  backgroundColor: Colors.teal.shade50,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatItem('Total Jam Kerja:', '6.5 jam', FontAwesomeIcons.mugHot, Colors.orange),
                      _buildStatItem('Jam Istirahat:', '30 menit', FontAwesomeIcons.mugSaucer, Colors.brown),
                      _buildStatItem('Kebiasaan Terpenuhi:', '$completedTasks/$totalTasks', FontAwesomeIcons.check, Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          FaIcon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
  
  // Quick Input
  Widget _buildQuickInputCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Input Cepat Aktivitas Baru...',
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const AddEditActivityDialog(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Tambahkan'),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder untuk Static Stats
  Widget _buildStaticStats() {
    return const Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text("Statistik Harian Lainnya...")),
      ),
    );
  }

  // Time Blocking (Menggantikan Activity Flow lama)
  Widget _buildTimeBlocking(List<Activity> activities, ActivityProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Time Blocking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              SizedBox(
                height: 450, // Sedikit lebih tinggi untuk tampilan yang lebih baik
                child: ListView.builder(
                  itemCount: 24, // 24 jam
                  itemBuilder: (context, index) {
                    final time = DateTime(DateTime.now().year, 
                        DateTime.now().month, DateTime.now().day, index);
                    
                    // Filter aktivitas yang terjadi pada jam ini
                    final hourlyActivities = activities.where((a) {
                      return a.startTime.hour == index;
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kolom Jam
                          SizedBox(
                            width: 50,
                            child: Text(
                               DateFormat('HH:mm').format(time), 
                               style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 8),

                          // Kolom Aktivitas (Menggunakan Wrap untuk multiline)
                          Expanded(
                            child: hourlyActivities.isNotEmpty
                            ? Wrap( 
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: hourlyActivities.map((a) => Chip(
                                  label: Text(
                                      a.title, 
                                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)
                                    ),
                                  // [FIX] Menggunakan warna dari Provider dengan opacity penuh
                                  backgroundColor: provider.getColorForType(a.type), 
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                )).toList(),
                              )
                            : Container(
                                // [FIX] Tampilkan garis abu-abu muda jika tidak ada aktivitas (untuk visual timeline)
                                height: 1.0, 
                                color: Colors.grey.shade300, 
                                margin: const EdgeInsets.only(top: 8)
                              ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }

  // Tugas Mendesak & Penting
  Widget _buildUrgentTasks(BuildContext context, List<Activity> activities) {
    // Hanya tampilkan 5 tugas yang belum selesai
    final pendingTasks = activities.where((a) => !a.isCompleted).take(5).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tugas Mendesak & Penting', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (pendingTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Semua tugas selesai!'),
              ),
            ...pendingTasks.map((activity) => ActivityCard(activity: activity)),
          ],
        ),
      ),
    );
  }

  // Pelacak Kebiasaan Baik
  Widget _buildHabitTracker(BuildContext context, List<Habit> habits) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lacak Kebiasaan Baikmu!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom per baris
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9, 
              ),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return HabitCard(habit: habits[index]);
              },
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                onPressed: () => showDialog(
                    context: context, builder: (context) => const AddEditHabitDialog()),
                icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 18),
                label: const Text('Tambah Kebiasaan Baru'),
                style: TextButton.styleFrom(foregroundColor: Colors.teal),
              ),
            )
          ],
        ),
      ),
    );
  }
}