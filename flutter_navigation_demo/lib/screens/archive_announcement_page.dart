import 'package:flutter/material.dart';

class ArchiveAnnouncementPage extends StatelessWidget {
  const ArchiveAnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arsip Pengumuman'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Arsip Tahun 2024',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 2),
          _buildArchiveTile('Pengumuman Hasil Seleksi Dosen Baru', '20 Des 2024'),
          _buildArchiveTile('Penutupan Pendaftaran Program Magang', '15 Nov 2024'),
          _buildArchiveTile('Jadwal Kuliah Semester Ganjil 2024/2025', '01 Sep 2024'),
          
          const SizedBox(height: 30),
          
          const Text(
            'Arsip Tahun 2023',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 2),
          _buildArchiveTile('Sosialisasi Kurikulum Baru', '10 Jan 2023'),
          _buildArchiveTile('Perayaan Dies Natalis Kampus ke-20', '05 Des 2023'),

          const SizedBox(height: 50),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Tutup Arsip'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade600,
                foregroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildArchiveTile(String title, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const Icon(Icons.history, color: Colors.blueGrey),
        title: Text(title),
        subtitle: Text('Tanggal: $date'),
        trailing: const Icon(Icons.download),
        onTap: () { /* Aksi download arsip */ },
      ),
    );
  }
}