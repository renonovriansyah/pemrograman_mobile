import 'package:flutter/material.dart';
import 'package:flutter_navigation_demo/screens/krs_page.dart';
import 'package:flutter_navigation_demo/screens/ukt_page.dart';
import 'event_registration_page.dart'; // Untuk Pop Result
import 'news_detail_page.dart'; // Untuk Navigasi Sederhana
import 'khs_page.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

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

  // Widget baru: Service Tile yang lebih kecil dan padat (4 kolom)
  Widget _buildCompactServiceTile(
      BuildContext context, 
      IconData icon, 
      String label, 
      Color color,
      VoidCallback onTapAction) { // <-- Menerima VoidCallback untuk aksi yang berbeda

    return InkWell(
      onTap: onTapAction, // <-- Memanggil aksi yang diterima
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color), 
            const SizedBox(height: 5),
            Text(
              label, 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogoHeader(),
          const Text(
            'Akses Cepat Layanan Akademik',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
          ),
          const Divider(thickness: 1, height: 20),
          
          // GridView.count dengan 4 kolom untuk tampilan yang padat
          GridView.count(
            crossAxisCount: 4, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.9, 
            children: [
              // 1. KRS: Navigasi Sederhana
              _buildCompactServiceTile(
                context, 
                Icons.assignment, 'Lihat KRS', Colors.orange.shade700, 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KRSPage()))
              ),
              
              // 2. Pembayaran: SnackBar (Feedback Cepat)
              _buildCompactServiceTile(
                context, 
                Icons.assignment, 'Bayar UKT', Colors.orange.shade700, 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UKTPage()))
              ),
              // 3. Jadwal Kuliah: Navigasi Sederhana
              _buildCompactServiceTile(
                context, 
                Icons.calendar_today, 'Jadwal Kuliah', Colors.purple.shade700, 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsDetailPage()))
              ),
              
              // 4. Webmail: SnackBar (Feedback Cepat)
              _buildCompactServiceTile(
                context, 
                Icons.email, 'Webmail', Colors.red.shade700, 
                () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mengalihkan ke Webmail kampus...')))
              ),
              
              // 5. Perpus Digital: Named Route
              _buildCompactServiceTile(
                context, 
                Icons.library_books, 'Perpus Digital', Colors.cyan.shade700, 
                () => Navigator.pushNamed(context, '/map', arguments: 'Akses Perpus Digital')
              ),
              
              // 6. Dosen Wali: Pop Result (Simulasi Form Pertemuan)
              _buildCompactServiceTile(
                context, 
                Icons.person_pin, 'Janjian Dosen', Colors.indigo.shade700, 
                () async {
                  final result = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const EventRegistrationPage())
                  );
                  if (result != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Janjian Dosen: ${result['nama']} (${result['acara']})')));
                  }
                }
              ),
              
              // 7. KHS: SnackBar (Feedback Cepat)
              _buildCompactServiceTile(
                context, 
                Icons.receipt_long, 'Lihat KHS', Colors.brown.shade700, 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KHSPage())) // <-- Ganti aksi
              ),
              
              // 8. Bantuan: Navigasi Sederhana
              _buildCompactServiceTile(
                context, 
                Icons.info, 'Helpdesk', Colors.blue.shade700, 
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsDetailPage()))
              ),
            ],
          ),
          
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}