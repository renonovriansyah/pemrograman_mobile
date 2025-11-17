// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// --- Import Konfigurasi Firebase ---
// File ini dihasilkan otomatis setelah Anda menjalankan flutterfire configure
import 'firebase_options.dart'; 

// --- Import Providers ---
import 'providers/activity_provider.dart';
import 'providers/habit_provider.dart';

// --- Import Screen Utama ---
import 'screens/home_screen.dart';

void main() async {
  // Pastikan inisialisasi widget Flutter selesai sebelum memanggil native code
  WidgetsFlutterBinding.ensureInitialized(); 

  // Inisialisasi Firebase Core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Menggunakan MultiProvider untuk mendaftarkan semua State Management
    MultiProvider(
      providers: [
        // Provider untuk Aktivitas Harian (CRUD)
        ChangeNotifierProvider(create: (context) => ActivityProvider()), 
        // Provider untuk Kebiasaan (Habits CRUD)
        ChangeNotifierProvider(create: (context) => HabitProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Activity Flow Tracker',
      debugShowCheckedModeBanner: false, // Biasanya disembunyikan untuk aplikasi produksi
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}