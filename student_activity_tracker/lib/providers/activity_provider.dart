import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart'; // Wajib: Activity Model
import '../models/activity_stats.dart'; // Wajib: ActivityStats Model

// Tipe data sederhana untuk distribusi Pie Chart
class PieChartDataPoint {
  final String category;
  final double durationMinutes;
  final Color color;

  PieChartDataPoint(this.category, this.durationMinutes, this.color);
}

class ActivityProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _userId = 'user_abc'; 

  // --- STREAM DATA FIREBASE (READ STABIL) ---
  Stream<List<Activity>> get activitiesStream {
    final today = DateTime.now();
    // Tentukan awal hari ini (00:00:00)
    final startOfToday = DateTime(today.year, today.month, today.day);
    // Tentukan awal hari besok (23:59:59 hari ini)
    final endOfToday = startOfToday.add(const Duration(days: 1));

    // Kueri menggunakan rentang waktu (wajib untuk data hari ini)
    return _db
        .collection('activities')
        .where('userId', isEqualTo: _userId)
        .where('startTime', isGreaterThanOrEqualTo: startOfToday) // Mulai dari 00:00:00
        .where('startTime', isLessThan: endOfToday) // Berakhir sebelum 00:00:00 besok
        .orderBy('startTime', descending: false)
        .withConverter<Activity>(
          fromFirestore: Activity.fromFirestore,
          toFirestore: (Activity act, _) => act.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // --- CRUD OPERATIONS (DIPERBAIKI UNTUK isImportant) ---

  Future<void> addActivity(Activity activity) async {
    // Pastikan ID pengguna disertakan dalam data yang disimpan
    await _db.collection('activities').doc(activity.id).set(activity.toFirestore());
  }

  Future<void> updateActivity(Activity activity) async {
    // Menggunakan toFirestore() untuk memastikan semua field (termasuk isImportant) terupdate
    await _db.collection('activities').doc(activity.id).update(activity.toFirestore());
  }

  Future<void> deleteActivity(String id) async {
    await _db.collection('activities').doc(id).delete();
  }


  // --- FUNGSI REPORTING & HELPER ---

  // 1. Mendapatkan Warna untuk Tipe Aktivitas
  Color getColorForType(ActivityType type) { 
    // [FIXED] Fungsi harus berada di dalam class dan menangani semua tipe
    switch (type) {
      case ActivityType.call:
        return Colors.green;
      case ActivityType.deepWork:
        return Colors.blue;
      case ActivityType.workout:
        return Colors.orange;
      case ActivityType.routine:
        return Colors.purple;
    }
  }

  // 2. Menghitung Statistik Durasi (untuk Home Screen Bar)
  List<ActivityStats> calculateDailyStats(List<Activity> activities) {
    final Map<ActivityType, Duration> typeDurations = {};
    for (var type in ActivityType.values) {
      typeDurations[type] = Duration.zero;
    }
    for (var activity in activities) {
      // Hanya hitung aktivitas hari ini 
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
  
  // 3. Menghitung Distribusi Waktu untuk Pie Chart (Kerja vs Lainnya)
  List<PieChartDataPoint> calculateTimeDistribution(List<Activity> activities) {
    // [METHOD HILANG DIKOMBINASIKAN DI SINI]
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
}