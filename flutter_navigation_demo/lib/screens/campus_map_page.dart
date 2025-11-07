import 'package:flutter/material.dart';

class CampusMapPage extends StatelessWidget {
  const CampusMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menerima argumen dari Named Route
    final data = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Kampus Interaktif'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 80, color: Colors.orange.shade600),
              const SizedBox(height: 30),
              const Text('Navigasi ke Lokasi Anda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Data Rute Diterima:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    const SizedBox(height: 5),
                    Text(
                      'Asal Akses: ${data ?? 'Tidak Diketahui'}',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Tutup Peta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
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