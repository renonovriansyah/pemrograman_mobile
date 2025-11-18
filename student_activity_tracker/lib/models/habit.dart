import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Habit {
  final String id;
  String title;
  int targetAmount; // Misalnya, ml air atau menit meditasi
  int currentAmount;
  String unit; // Misalnya, "ml" atau "mins"
  final String userId = 'user_abc'; // ID user statis

  Habit({
    String? id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.unit,
  }) : id = id ?? const Uuid().v4();

  // Konversi dari Firestore (PASTIKAN FIELD TIDAK NULL)
  factory Habit.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Habit(
      id: snapshot.id,
      title: data?['title'] ?? '',
      // PASTIKAN SEMUA INTEGER MENGGUNAKAN || 0
      targetAmount: (data?['targetAmount'] as int?) ?? 0, 
      currentAmount: (data?['currentAmount'] as int?) ?? 0,
      unit: data?['unit'] ?? '',
    );
  }

  // Konversi ke Firestore
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