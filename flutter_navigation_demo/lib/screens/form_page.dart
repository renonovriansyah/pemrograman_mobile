import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  const FormPage ({super.key});

  @override
  Widget build(BuildContext context) {
    // Menerima data melalui named route arguments [cite: 85]
    final data = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Named Route Page (/form)'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 80, color: Colors.orange.shade600),
              const SizedBox(height: 20),
              const Text(
                'Navigasi Menggunakan Named Route',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  'Argumen Diterima:\n"${data ?? 'Tidak ada data'}"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali (POP)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
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