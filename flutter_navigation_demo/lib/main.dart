// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/main_campus_screen.dart';
import 'screens/student_profile_detail_page.dart';
import 'screens/campus_map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Explorer Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF001F3F)),
        useMaterial3: true,
      ),
      // --- PERBAIKAN DI SINI: Gunakan initialRoute dan definisikan '/' di routes ---
      initialRoute: '/', // Mulai dari rute bernama '/'
      routes: {
        '/': (context) => const MainCampusScreen(), // Halaman Home/Bottom Nav Bar
        '/detail': (context) => const StudentProfileDetailPage(), 
        '/map': (context) => const CampusMapPage(),            
      },
      // HAPUS properti 'home: const MainCampusScreen(),'
    );
  }
}