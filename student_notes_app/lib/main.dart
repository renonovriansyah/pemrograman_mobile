import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart'; // PENTING: Untuk format tanggal Indo
import 'home_page.dart';
import 'storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  // 2. Set status bar transparan default
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Default icon gelap
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load tema terakhir yang disimpan user
  void _loadTheme() async {
    bool dark = await StorageService.loadTheme();
    setState(() {
      isDarkMode = dark;
      _updateStatusBar(dark);
    });
  }

  // Simpan dan ganti tema
  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
      _updateStatusBar(value);
    });
    StorageService.saveTheme(value);
  }

  // Update warna icon status bar agar kontras
  void _updateStatusBar(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Kamu',
      debugShowCheckedModeBanner: false,

      // KONFIGURASI ANIMASI TRANSISI TEMA (Supaya Smooth)
      themeAnimationDuration: const Duration(milliseconds: 500),
      themeAnimationCurve: Curves.easeInOut,

      // --- TEMA TERANG (LIGHT) ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Putih keabuan bersih
        // Ganti Font jadi Poppins
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),

      // --- TEMA GELAP (DARK) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C), // Warna gelap elegan
        // Ganti Font jadi Poppins & sesuaikan warna teks
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF), 
          brightness: Brightness.dark
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),

      // Logika Pemilihan Tema
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      home: HomePage(
        isDarkMode: isDarkMode, 
        onThemeChanged: _toggleTheme
      ),
    );
  }
}