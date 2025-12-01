// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spectrum Flow Todo',
      theme: ThemeData(
        primaryColor: Colors.deepPurple, // Warna primer utama
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple, // Menggunakan Colors.deepPurple
        ).copyWith(
          secondary: Colors.pinkAccent, // Warna sekunder
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5), // Sesuaikan background scaffold
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
        ),
        useMaterial3: false, // Untuk konsistensi desain yang mirip Material 2
      ),
      home: const TodoListScreen(),
    );
  }
}