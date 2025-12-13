import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:intl/date_symbol_data_local.dart';
import 'pages/form_page.dart';

// Ubah main menjadi async untuk persiapan inisialisasi
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Enroll Pro',
      
      // --- TEMA APLIKASI YANG DIPERBARUI ---
      theme: ThemeData(
        useMaterial3: true,
        
        // 1. Warna Dasar & Skema Warna Professional
        scaffoldBackgroundColor: const Color(0xFFF8F9FD), // Background soft (bukan putih polos)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo (Warna Utama)
          secondary: const Color(0xFF0EA5E9), // Sky Blue (Warna Aksen)
          surface: Colors.white,
          brightness: Brightness.light,
        ),

        // 2. Typography Modern (Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),

        // 3. Styling Input Field (Modern & Clean)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          
          // Border saat tidak diklik
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          
          // Border saat diklik (Fokus)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
          ),
          
          // Border saat error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),

        // 4. Styling Tombol (Elevated Button)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            elevation: 3, // Sedikit bayangan
            shadowColor: const Color(0xFF4F46E5).withAlpha(23),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        // 5. Styling App Bar
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF8F9FD),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF1E293B), // Dark Blue Grey
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        ),
      ),
      
      // Halaman Utama
      home: const FormMahasiswaValidasiPage(),
    );
  }
}