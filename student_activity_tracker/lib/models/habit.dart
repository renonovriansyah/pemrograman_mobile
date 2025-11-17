// lib/models/habit.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  String title;
  int targetAmount; // Contoh: 8 gelas air, 10 menit meditasi
  int currentAmount;
  String unit; // Contoh: 'ml', 'mins', 'times'
  final String userId = 'user_abc'; // Ganti dengan ID user yang sebenarnya

  Habit({
    String? id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.unit,
  }) : id = id ?? const Uuid().v4();

  factory Habit.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Habit(
      id: snapshot.id,
      title: data?['title'] ?? '',
      targetAmount: data?['targetAmount'] ?? 0,
      currentAmount: data?['currentAmount'] ?? 0,
      unit: data?['unit'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "targetAmount": targetAmount,
      "currentAmount": currentAmount,
      "unit": unit,
      "userId": userId,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}