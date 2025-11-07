import 'package:flutter/material.dart';
import 'main_campus_screen.dart';

class SignOutSuccessPage extends StatelessWidget {
  const SignOutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Keluar Akun'),
        backgroundColor: Colors.red.shade600,
        automaticallyImplyLeading: false, // Penting untuk PushReplacement
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.red.shade700),
              const SizedBox(height: 30),
              const Text('Sesi Anda Telah Berakhir', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 10),
              const Text(
                'Anda telah disimulasikan Log Out. Halaman sebelumnya telah diganti (Push Replacement).',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () {
                  // Menggunakan PushReplacement untuk kembali ke Home tanpa menyimpan riwayat halaman ini
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainCampusScreen()),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}