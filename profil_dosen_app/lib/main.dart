import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/dosen_provider.dart';
import 'providers/mahasiswa_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftarkan Provider di sini agar bisa diakses oleh semua screen di bawahnya
    return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DosenProvider()),
      ChangeNotifierProvider(create: (context) => MahasiswaProvider()),
    ],
    child: MaterialApp(
      title: 'Direktori Dosen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A2647),
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    ),
  );
  }
}