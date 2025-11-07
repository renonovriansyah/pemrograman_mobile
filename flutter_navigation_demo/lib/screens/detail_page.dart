import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage ({super.key});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menerima data dari RouteSettings arguments [cite: 85]
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mahasiswa (Data Diterima)'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Profil Mahasiswa (Data Diterima)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Nama', args?['nama'] ?? 'Tidak ada data'),
                    const Divider(height: 20),
                    _buildDetailRow('NPM', args?['npm'] ?? 'Tidak ada data'),
                    const Divider(height: 20),
                    _buildDetailRow('Jurusan', args?['jurusan'] ?? 'Tidak ada data'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali (POP)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}