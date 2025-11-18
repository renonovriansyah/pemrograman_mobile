// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Gunakan ID statis yang sama dengan Activity dan Habit
  final String _userId = 'user_abc'; 

  UserProfile? _profile;
  UserProfile? get profile => _profile;

  UserProvider() {
    _loadProfile();
  }

  // READ: Stream Profile
  void _loadProfile() {
    _db.collection('users').doc(_userId).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        // Data ada, gunakan data dari Firestore
        _profile = UserProfile.fromFirestore(snapshot);
      } else {
        // Data belum ada di Firestore, gunakan default
        _profile = UserProfile(id: _userId);
        // Simpan data default ini ke Firestore agar user_abc terdaftar
        _saveProfile(_profile!); 
      }
      notifyListeners();
    });
  }

  // CREATE/UPDATE: Simpan Profile ke Firestore
  Future<void> _saveProfile(UserProfile newProfile) async {
    await _db.collection('users').doc(_userId).set(newProfile.toFirestore());
  }

  // Public method untuk mengupdate dari UI
  Future<void> updateProfile(String newName, String newEmail) async {
    if (_profile != null) {
      _profile!.name = newName;
      _profile!.email = newEmail;
      await _saveProfile(_profile!);
      notifyListeners();
    }
  }
}