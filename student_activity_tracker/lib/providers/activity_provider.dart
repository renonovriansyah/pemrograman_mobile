// lib/providers/activity_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity.dart';
import 'package:flutter/material.dart';
import '../models/activity_stats.dart';

class ActivityProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ActivityStats> calculateDailyStats(List<Activity> activities) {
    final Map<ActivityType, Duration> typeDurations = {};
    
    // Logika perhitungan durasi...
    for (var type in ActivityType.values) {
      typeDurations[type] = Duration.zero;
    }
    for (var activity in activities) {
      final duration = activity.endTime.difference(activity.startTime);
      typeDurations[activity.type] = typeDurations[activity.type]! + duration;
    }
    
    // Konversi ke ActivityStats
    return typeDurations.entries.map((entry) {
      final durationHours = entry.value.inMinutes / 60.0;
      final typeName = entry.key.toString().split('.').last;
      
      // Menggunakan fungsi warna yang sudah kita pindahkan
      Color color = getColorForType(entry.key); 

      return ActivityStats(
        title: typeName,
        durationHours: durationHours,
        color: color,
      );
    }).where((stat) => stat.durationHours > 0).toList();
  }
  
Color getColorForType(ActivityType type) { // Gunakan nama public (tanpa _)
  switch (type) {
    case ActivityType.call:
      return Colors.green;
    case ActivityType.deepWork:
      return Colors.blue;
    case ActivityType.workout:
      return Colors.orange;
    case ActivityType.routine:
      return Colors.blueGrey;
  }
}
  
  // Menggunakan Stream untuk mendapatkan data secara real-time
  Stream<List<Activity>> get activitiesStream {
    return _db
        .collection('activities')
        .where('userId', isEqualTo: 'user_abc') // Filter data per user
        .orderBy('startTime', descending: false)
        .withConverter<Activity>(
          fromFirestore: Activity.fromFirestore,
          toFirestore: (activity, _) => activity.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // 1. CREATE (Menambah Aktivitas Baru)
  Future<void> addActivity(Activity activity) async {
    try {
      await _db.collection('activities').doc(activity.id).set(activity.toFirestore());
      if (kDebugMode) {
        print('Activity added: ${activity.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding activity: $e');
      }
    }
  }

  // 2. READ (Data sudah di-handle oleh Stream di atas)

  // 3. UPDATE (Mengubah Status Selesai atau Detail Lain)
  Future<void> updateActivity(Activity activity) async {
    try {
      await _db.collection('activities').doc(activity.id).update(
        {
          'title': activity.title,
          'startTime': Timestamp.fromDate(activity.startTime),
          'endTime': Timestamp.fromDate(activity.endTime),
          'isCompleted': activity.isCompleted,
        }
      );
      if (kDebugMode) {
        print('Activity updated: ${activity.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating activity: $e');
      }
    }
  }

  // 4. DELETE (Menghapus Aktivitas)
  Future<void> deleteActivity(String activityId) async {
    try {
      await _db.collection('activities').doc(activityId).delete();
      if (kDebugMode) {
        print('Activity deleted: $activityId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting activity: $e');
      }
    }
  }
}