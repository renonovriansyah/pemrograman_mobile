// lib/providers/habit_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

class TrendChartData {
  final int dayOffset; // 0=Hari ini, 9=10 hari lalu
  final double completionRate; // Nilai 0 hingga 1.0 (0% sampai 100%)

  TrendChartData(this.dayOffset, this.completionRate);
}

class HabitProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // READ (Stream untuk Kebiasaan)
  Stream<List<Habit>> get habitsStream {
    return _db
        .collection('habits')
        .where('userId', isEqualTo: 'user_abc')
        .withConverter<Habit>(
          fromFirestore: Habit.fromFirestore,
          toFirestore: (habit, _) => habit.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // CREATE
  Future<void> addHabit(Habit habit) async {
    await _db.collection('habits').doc(habit.id).set(habit.toFirestore());
  }

  // UPDATE (Update Progres)
  Future<void> updateHabitProgress(String habitId, int amount) async {
    await _db.collection('habits').doc(habitId).update({
      'currentAmount': amount,
    });
  }

  // DELETE
  Future<void> deleteHabit(String habitId) async {
    await _db.collection('habits').doc(habitId).delete();
  }

  List<TrendChartData> calculateTrend() {
  List<TrendChartData> data = [];
  
  // Menghasilkan 10 titik data tren dummy
  for (int i = 9; i >= 0; i--) {
    // Logika dummy: Membuat tren yang fluktuatif (rate antara 40% - 100%)
    double rate = (0.5 + (i % 3) * 0.1 - (i % 2) * 0.05).clamp(0.4, 1.0);
    data.add(TrendChartData(i, rate));
  }
  
    return data;
  }
}