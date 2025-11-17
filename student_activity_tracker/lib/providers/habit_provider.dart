// lib/providers/habit_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

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
}