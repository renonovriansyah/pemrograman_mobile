// lib/models/user.dart

import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String avatarLetter;
  final Color avatarColor;

  User({
    required this.name,
    required this.email,
    required this.avatarLetter,
    required this.avatarColor,
  });

  /// Metode untuk membuat salinan objek User dengan properti yang dimodifikasi.
  /// Ini penting untuk pola State Management di Flutter.
  User copyWith({
    String? name,
    String? email,
    String? avatarLetter,
    Color? avatarColor,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarLetter: avatarLetter ?? this.avatarLetter,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}