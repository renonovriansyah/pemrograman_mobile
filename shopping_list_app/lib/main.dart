import 'package:flutter/material.dart';
// Pastikan nama file import ini sesuai dengan nama file kamu
import 'screens/smart_shop_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartShop List',
      theme: ThemeData(
        // Mengubah warna utama aplikasi menjadi Teal sesuai desain
        primarySwatch: Colors.teal, 
        useMaterial3: false, 
      ),
      // PENTING: Pastikan ini memanggil SmartShopPage()
      home: const SmartShopPage(), 
    );
  }
}
