import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:intl/date_symbol_data_local.dart';
import 'pages/form_page.dart';

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
      
      // --- TEMA APLIKASI MODERN ---
      theme: ThemeData(
        useMaterial3: true,
        
        // 1. Warna Dasar & Skema Warna
        // Menggunakan warna Slate-100 agar sama persis dengan background FormPage
        scaffoldBackgroundColor: const Color(0xFFF1F5F9), 
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo (Warna Gradien Utama)
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF0EA5E9), // Sky Blue
          surface: Colors.white,
          // Mengatur tint surface agar dialog tidak berwarna pinkish/ungu di Material 3
          surfaceTint: Colors.transparent, 
        ),

        // 2. Typography Modern (Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),

        // 3. Global Dialog Theme (Agar Alert Dialog Reset terlihat modern)
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: const Color(0xFF1E293B)
          ),
        ),

        // 4. Cursor & Selection Color
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: const Color(0xFF6366F1),
          selectionColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
          selectionHandleColor: const Color(0xFF6366F1),
        ),

        // 5. Styling Input Field
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          
          // Border saat tidak diklik
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          
          // Border saat diklik (Fokus)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          
          // Border saat error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),

        // 6. Styling Tombol (Elevated Button)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: const Color(0xFF6366F1).withValues(alpha: 0.4),
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

        // 7. Styling App Bar
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF1F5F9),
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