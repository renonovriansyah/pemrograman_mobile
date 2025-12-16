import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"), // Pastikan file ini ada!
          fit: BoxFit.cover, // Menutupi seluruh layar
          opacity: 0.1, // Transparansi agar tidak mengganggu teks (atur 0.05 - 0.2)
        ),
        color: Color(0xFFFAFAFA), // Warna dasar backup jika gambar gagal load
      ),
      child: child,
    );
  }
}