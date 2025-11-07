import 'package:flutter/material.dart';

class FormInputPage extends StatefulWidget {
  const FormInputPage ({super.key});

  @override
  State<FormInputPage> createState() => _FormInputPageState();
}

class _FormInputPageState extends State<FormInputPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input & Kirim Hasil Kembali'),
        backgroundColor: Colors.purple.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Form Pendaftaran Acara Kampus',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Kampus',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Mengirim data kembali ke halaman sebelumnya menggunakan Navigator.pop(result) [cite: 60]
                final data = {
                  'nama': _namaController.text,
                  'email': _emailController.text,
                };
                Navigator.pop(context, data); // Mengirim Map sebagai hasil
              },
              icon: const Icon(Icons.assignment_turned_in),
              label: const Text('Daftar & Kirim Hasil (POP Result)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.cancel),
              label: const Text('Batal'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                foregroundColor: Colors.purple.shade600,
                side: BorderSide(color: Colors.purple.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}