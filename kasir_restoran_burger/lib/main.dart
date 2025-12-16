import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'data/firestore_service.dart'; 
import 'features/menu/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- KONEKSI FIREBASE ---
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA57i0v2ccWznb30Vy4xN-F_DEnWlLEwfA",
      authDomain: "sizzleburger-32776.firebaseapp.com",
      projectId: "sizzleburger-32776",
      storageBucket: "sizzleburger-32776.firebasestorage.app",
      messagingSenderId: "659728869664",
      appId: "1:659728869664:web:a3add7843561922a660f45",
      measurementId: "G-ZJ7D8CQ6DV",
    ),
  );

  // Cek & Isi Data awal jika kosong
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
      title: 'Sizzle Burger POS',
      debugShowCheckedModeBanner: false,
      
      // --- TEMA GLOBAL APLIKASI ---
      theme: ThemeData(
        // 1. Set Font Global ke 'Poppins' agar terlihat profesional & rapi
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        
        // 2. Warna Utama (Maroon Sizzle Burger)
        primaryColor: const Color(0xFF720E1E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF720E1E),
          primary: const Color(0xFF720E1E),
          secondary: const Color(0xFFFFCD05), // Kuning Aksen
        ),
        
        // 3. Style Default AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF720E1E),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, 
            fontSize: 18, 
            color: Colors.white
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // 4. Background Scaffold Default
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        
        useMaterial3: true,
      ),
      
      home: const MenuScreen(),
    );
  }
}