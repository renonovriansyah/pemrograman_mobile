import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';
import '../models/activity_stats.dart'; 

// --- MODEL DATA UNTUK GRAFIK ---

class PieChartDataPoint {
  final String category;
  final double durationMinutes;
  final Color color;

  PieChartDataPoint(this.category, this.durationMinutes, this.color);
}

class WeeklyChartData {
  final int dayIndex; // 1=Senin, 7=Minggu
  final double durationHours;

  WeeklyChartData(this.dayIndex, this.durationHours);
}

// --- CLASS UTAMA PROVIDER ---

class ActivityProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _userId = 'user_abc'; 
  String get currentUserId => _userId;

  Stream<List<Activity>> get activitiesStream {
    
    // Kueri dengan filter rentang waktu HARI INI
    return _db
        .collection('activities')
        .where('userId', isEqualTo: _userId)
        .orderBy('startTime', descending: false)
        .withConverter<Activity>(
          fromFirestore: Activity.fromFirestore,
          toFirestore: (Activity act, _) => act.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // --- CRUD OPERATIONS ---
  Future<void> addActivity(Activity activity) async {
    await _db.collection('activities').doc(activity.id).set(activity.toFirestore());
  }

  Future<void> updateActivity(Activity activity) async {
    await _db.collection('activities').doc(activity.id).update(activity.toFirestore());
  }

  Future<void> deleteActivity(String id) async {
    await _db.collection('activities').doc(id).delete();
  }

  // --- FUNGSI REPORTING & HELPER ---

  // 1. Mendapatkan Warna untuk Tipe Aktivitas
  Color getColorForType(ActivityType type) { 
  switch (type) {
    case ActivityType.call:
      // Warna Hijau lebih kalem
      return const Color.fromARGB(255, 136, 203, 139); 
    case ActivityType.deepWork:
      // Warna Biru yang lebih dalam/matang
      return const Color.fromARGB(255, 125, 157, 190); 
    case ActivityType.workout:
      // Warna Oranye kecoklatan
      return const Color.fromARGB(255, 245, 193, 142); 
    case ActivityType.routine:
      // Warna Ungu yang lebih lembut
      return const Color.fromARGB(255, 190, 144, 198); 
    }
  }

  // 2. Menghitung Statistik Durasi (Home Screen Bar)
  List<ActivityStats> calculateDailyStats(List<Activity> activities) {
    // Karena stream sudah difilter untuk hari ini, kita tidak perlu membandingkan tanggal secara lokal.
    final Map<ActivityType, Duration> typeDurations = {};
    
    for (var type in ActivityType.values) {
      typeDurations[type] = Duration.zero;
    }
    
    for (var activity in activities) {
      final duration = activity.endTime.difference(activity.startTime);
      typeDurations[activity.type] = typeDurations[activity.type]! + duration;
    }
    
    return typeDurations.entries.map((entry) {
      final durationHours = entry.value.inMinutes / 60.0;
      final typeName = entry.key.toString().split('.').last;
      Color color = getColorForType(entry.key); 
      return ActivityStats(
        title: typeName,
        durationHours: durationHours,
        color: color,
      );
    }).where((stat) => stat.durationHours > 0).toList();
  }

  // 3. Menghitung Distribusi Waktu untuk Pie Chart
  List<PieChartDataPoint> calculateTimeDistribution(List<Activity> activities) {
    double totalWorkMinutes = 0;
    double totalOtherMinutes = 0; 

    for (var activity in activities) {
      final duration = activity.endTime.difference(activity.startTime).inMinutes.toDouble();
      
      if (activity.type == ActivityType.deepWork || activity.type == ActivityType.call) {
        totalWorkMinutes += duration; 
      } else {
        totalOtherMinutes += duration; 
      }
    }

    if (totalWorkMinutes + totalOtherMinutes == 0) {
      return [ PieChartDataPoint("Kosong", 1.0, Colors.grey) ];
    }

    return [
      PieChartDataPoint("Kerja (Work/Call)", totalWorkMinutes, Colors.blue),
      PieChartDataPoint("Lainnya (Workout/Routine)", totalOtherMinutes, Colors.orange),
    ];
  }
  
  // 4. Menghitung Produktivitas Mingguan (untuk Report Screen Bar Chart)
  List<WeeklyChartData> calculateWeeklyProductivity(List<Activity> activities) {
    Map<int, Duration> dailyDurations = {}; // Key: Hari (1-7)
    
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    
    // Filter data untuk 7 hari terakhir
    final recentActivities = activities.where((a) => a.startTime.isAfter(sevenDaysAgo)).toList();

    for (var activity in recentActivities) {
      final dayOfWeek = activity.startTime.weekday; 
      final duration = activity.endTime.difference(activity.startTime);

      dailyDurations.update(
        dayOfWeek,
        (existingDuration) => existingDuration + duration,
        ifAbsent: () => duration,
      );
    }

    // Buat daftar 7 hari dengan data dari Durasi Harian
    List<WeeklyChartData> chartData = [];
    for (int i = 1; i <= 7; i++) { 
      final duration = dailyDurations[i] ?? Duration.zero;
      chartData.add(WeeklyChartData(
        i, 
        duration.inMinutes / 60.0,
      ));
    }

    return chartData;
  }
}