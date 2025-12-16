import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Wajib Firebase
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'data/firestore_service.dart'; 
import 'features/menu/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- KONEKSI FIREBASE (VERSI FLUTTER) ---
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // Data ini diambil dari config yang kamu kirim tadi:
      apiKey: "AIzaSyA57i0v2ccWznb30Vy4xN-F_DEnWlLEwfA",
      authDomain: "sizzleburger-32776.firebaseapp.com",
      projectId: "sizzleburger-32776",
      storageBucket: "sizzleburger-32776.firebasestorage.app",
      messagingSenderId: "659728869664",
      appId: "1:659728869664:web:a3add7843561922a660f45",
      measurementId: "G-ZJ7D8CQ6DV",
    ),
  );

  // Cek & Isi Data awal jika kosong (Fitur Seeding yang kita buat)
  await FirestoreService().seedInitialData();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sizzle Burger Web',
      debugShowCheckedModeBanner: false,
      theme: sizzleTheme(),
      home: const MenuScreen(),
    );
  }
}