// lib/screens/announcement_tab.dart
import 'package:flutter/material.dart';
import 'archive_announcement_page.dart'; 

class AnnouncementTab extends StatelessWidget {
 const AnnouncementTab({super.key});

 // Widget untuk Berita/Pengumuman
 Widget _buildNewsItem(BuildContext context, String title, String subtitle, {VoidCallback? onTap}) {
  return Card(
   elevation: 1,
   margin: const EdgeInsets.symmetric(vertical: 8),
   child: ListTile(
        // UBAH KE Image.asset (Asumsikan ada file 'assets/news_image.jpg')
    leading: Image.asset('assets/logo.png', width: 50, height: 50, fit: BoxFit.cover),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
    onTap: onTap,
   ),
  );
 }

 @override
Widget build(BuildContext context) {
  // Pindahkan padding 15.0 keluar dari widget Padding dan jadikan sebagai variable
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      
      // 2. Judul (Diberi padding horizontal 15.0)
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BERITA & PENGUMUMAN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 10),
          ],
        ),
      ),
      
      // 3. Konten Kartu (TIDAK ADA PADDING HORIZONTAL DI SINI)
      _buildNewsItem(
        context,
        'Rektor Sambut Mahasiswa Baru, Semangat Kampus Merdeka!',
        'Lebih dari 3000 mahasiswa baru yang mendaftar di UBTI',
        onTap: () {
          // Navigasi
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

      const SizedBox(height: 20),
      
      // 4. LIHAT ARSIP (Diberi padding horizontal 15.0)
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.archive, color: Color(0xFF001F3F)),
          title: const Text('Lihat Semua Arsip Pengumuman', style: TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ArchiveAnnouncementPage()));
                },
              ), 
        ),
   ],
  );
 }
}