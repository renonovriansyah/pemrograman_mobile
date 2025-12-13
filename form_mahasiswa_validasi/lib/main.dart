import 'package:flutter/material.dart';
// 1. TAMBAHKAN IMPORT INI
import 'package:intl/date_symbol_data_local.dart'; 
import 'pages/form_page.dart';

// 2. UBAH MAIN MENJADI ASYNC
Future<void> main() async {
  // Pastikan binding terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. INISIALISASI FORMAT TANGGAL INDONESIA
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
      theme: ThemeData(
        // ... (kode tema Anda yang lama tetap sama) ...
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EA),
          secondary: const Color(0xFF00BFA5),
          surface: const Color(0xFFF3F4F6),
        ),
        inputDecorationTheme: InputDecorationTheme(
            // ... copy paste style lama Anda di sini ...
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6200EA), width: 2)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6200EA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const FormMahasiswaValidasiPage(),
    );
  }
}