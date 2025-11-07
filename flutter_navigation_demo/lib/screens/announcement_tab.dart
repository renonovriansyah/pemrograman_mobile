// lib/screens/announcement_tab.dart
import 'package:flutter/material.dart';


class AnnouncementTab extends StatelessWidget {
  const AnnouncementTab({super.key});

  // Widget Header Logo (Bisa dibuat terpisah)
  Widget _buildLogoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/logo.png', height: 40, width: 40), // Logo Anda
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UNIVERSITAS', style: TextStyle(fontSize: 12)),
                Text('BHINNEKA TUNGGAL IKA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const Divider(height: 30, thickness: 1),
      ],
    );
  }

  // Widget untuk Berita/Pengumuman (Meniru image_33717d.png)
  Widget _buildNewsItem(BuildContext context, String title, String subtitle, {VoidCallback? onTap}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network('https://i.pravatar.cc/150?img=10', width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. INTEGRASI LOGO HEADER
          _buildLogoHeader(),
          
          // 2. Judul
          const Text('BERITA & PENGUMUMAN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 10),

          // 3. Konten (List Berita/Pengumuman)
          _buildNewsItem(
            context,
            'Rektor Sambut Mahasiswa Baru, Semangat Kampus Merdeka!',
            'Lebih dari 3000 mahasiswa baru yang mendaftar di UBTI',
            onTap: () {
              // Navigasi ke Halaman Log Out (Simulasi)
              Navigator.pushNamed(context, '/logout_status'); 
            },
          ),
          _buildNewsItem(
            context,
            'Beasiswa Unggulan Tahap II: Pendaftaran Dibuka!',
            'Periode pendaftaran hingga akhir bulan ini.',
          ),
          _buildNewsItem(
            context,
            'Perpustakaan Digital Buka 24 Jam',
            'Akses ribuan jurnal akademik gratis sekarang.',
          ),

        ],
      ),
    );
  }
}