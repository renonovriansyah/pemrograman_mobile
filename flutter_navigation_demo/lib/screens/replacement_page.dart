import 'package:flutter/material.dart';
import 'main_campus_screen.dart';

class ReplacementPage extends StatelessWidget {
  const ReplacementPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Pengganti (Replacement)'),
        backgroundColor: Colors.red.shade600,
        // Dihilangkan karena PushReplacement menghapus halaman Home dari stack
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_sweep, size: 80, color: Colors.red.shade600),
              const SizedBox(height: 20),
              const Text(
                'Peringatan Push Replacement!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Kembali ke home dengan mengganti halaman ini
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainCampusScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Ganti Kembali ke Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}