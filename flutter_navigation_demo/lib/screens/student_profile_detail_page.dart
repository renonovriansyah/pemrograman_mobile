import 'package:flutter/material.dart';

class StudentProfileDetailPage extends StatelessWidget {
  const StudentProfileDetailPage({super.key});

  Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 18, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menerima data yang dikirim dari halaman asal
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Data Mahasiswa'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verifikasi Data Profil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 20),

            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDetailRow('Nama', args?['nama'] ?? 'Tidak ada data', Icons.person, Colors.blue),
                    const Divider(),
                    _buildDetailRow('NPM', args?['npm'] ?? 'Tidak ada data', Icons.numbers, Colors.green),
                    const Divider(),
                    _buildDetailRow('Fakultas', args?['jurusan'] ?? 'Tidak ada data', Icons.school, Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Tutup Detail Profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}