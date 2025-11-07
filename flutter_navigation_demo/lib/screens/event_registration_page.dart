import 'package:flutter/material.dart';

class EventRegistrationPage extends StatefulWidget {
  const EventRegistrationPage({super.key});

  @override
  State<EventRegistrationPage> createState() => _EventRegistrationPageState();
}

class _EventRegistrationPageState extends State<EventRegistrationPage> {
  final _namaController = TextEditingController();
  final _acaraController = TextEditingController(text: 'Acara Pekan Ilmiah');

  @override
  void dispose() {
    _namaController.dispose();
    _acaraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pendaftaran Acara'),
        backgroundColor: Colors.purple.shade600,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Konfirmasi Kehadiran Acara', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            const Text('Data ini akan dikirim kembali ke halaman Home (Fungsi Pop Result).', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 30),

            TextField(
              controller: _acaraController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Nama Acara',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                prefixIcon: Icon(Icons.event_note),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Pendaftar',
                hintText: 'Masukkan nama Anda',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                // FUNGSI POP RESULT
                final data = {
                  'nama': _namaController.text.isEmpty ? 'Anonim' : _namaController.text,
                  'acara': _acaraController.text,
                };
                Navigator.pop(context, data); // Mengirim Map sebagai hasil
              },
              icon: const Icon(Icons.assignment_turned_in),
              label: const Text('Daftar & Kirim Konfirmasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}