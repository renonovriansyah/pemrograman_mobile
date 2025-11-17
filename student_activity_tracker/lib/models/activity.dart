// lib/models/activity.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum ActivityType { call, deepWork, workout, routine }

class Activity {
  final String id;
  String title;
  DateTime startTime;
  DateTime endTime;
  ActivityType type;
  bool isCompleted;
  final String userId = 'user_abc'; // Ganti dengan ID user yang sebenarnya

  Activity({
    String? id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  // Konversi dari Firebase Map
  factory Activity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Activity(
      id: snapshot.id,
      title: data?['title'] ?? '',
      startTime: (data?['startTime'] as Timestamp).toDate(),
      endTime: (data?['endTime'] as Timestamp).toDate(),
      type: ActivityType.values.firstWhere(
          (e) => e.toString().split('.').last == data?['type'],
          orElse: () => ActivityType.routine),
      isCompleted: data?['isCompleted'] ?? false,
    );
  }

  // Konversi ke Firebase Map
  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "startTime": Timestamp.fromDate(startTime),
      "endTime": Timestamp.fromDate(endTime),
      "type": type.toString().split('.').last, // Simpan sebagai string
      "isCompleted": isCompleted,
      "userId": userId,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}