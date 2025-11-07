import 'package:flutter/material.dart';

class CampusInfoScreen extends StatelessWidget {
  const CampusInfoScreen({super.key});

  Widget _buildServiceTile(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () { /* Aksi ke layanan */ },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 5),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Portal Informasi Kampus',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1976D2)),
            ),
            const Divider(thickness: 2, height: 30),
            
            // Card Pengumuman
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🔔 Pengumuman Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.date_range, color: Colors.redAccent),
                      title: const Text('Batas Akhir KRS Semester Genap'),
                      subtitle: const Text('Jumat, 15 Desember 2025'),
                      onTap: () { /* Aksi detail */ },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.teal),
                      title: const Text('Peresmian Gedung Baru Fakultas TI'),
                      subtitle: const Text('Selasa, 10 Oktober 2025'),
                      onTap: () { /* Aksi detail */ },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card Layanan Cepat
            const Text('Akses Cepat Layanan Akademik', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildServiceTile(Icons.assignment, 'KRS', Colors.orange),
                _buildServiceTile(Icons.account_balance_wallet, 'Pembayaran', Colors.green),
                _buildServiceTile(Icons.calendar_today, 'Jadwal', Colors.purple),
                _buildServiceTile(Icons.email, 'Webmail', Colors.red),
                _buildServiceTile(Icons.settings, 'Pengaturan', Colors.grey),
                _buildServiceTile(Icons.info, 'Bantuan', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}