// lib/models/user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  String name;
  String email;

  UserProfile({
    required this.id,
    this.name = 'Pengguna Aktiva',
    this.email = 'email@example.com',
  });

  // Konversi dari Firestore
  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserProfile(
      id: snapshot.id,
      name: data['name'] ?? 'Pengguna Aktiva',
      email: data['email'] ?? 'email@example.com',
    );
  }

  // Konversi ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
    };
  }
}