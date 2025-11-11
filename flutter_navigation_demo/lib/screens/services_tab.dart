import 'package:flutter/material.dart';
import 'package:flutter_navigation_demo/screens/krs_page.dart';
import 'package:flutter_navigation_demo/screens/schedule_page.dart';
import 'package:flutter_navigation_demo/screens/ukt_page.dart';
import 'khs_page.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  // Header biru universitas
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF001F3F),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/logo.png', height: 35, width: 35),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UNIVERSITAS',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('BHINNEKA TUNGGAL IKA',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Icon(Icons.menu, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildCompactServiceTile(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTapAction,
  ) {
    return InkWell(
      onTap: onTapAction,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(30),
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
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

 @override
 Widget build(BuildContext context) {
 // Menggunakan Column karena SingleChildScrollView sudah ditangani oleh parent
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Padding(
 padding: const EdgeInsets.all(16.0),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Text('Akses Cepat Layanan Akademik',
 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87), // Diubah menjadi hitam
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
 // 1. KRS
 _buildCompactServiceTile(
 context,
 Icons.assignment, 'Lihat KRS', Colors.orange.shade700,
 () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KRSPage()))
 ), 
 // 2. Pembayaran UKT
 _buildCompactServiceTile(
 context,
 Icons.account_balance_wallet, 'Bayar UKT', Colors.green.shade700,
 () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UKTPage()))
 ),
 // 3. Jadwal Kuliah
 _buildCompactServiceTile(
 context,
 Icons.calendar_today, 'Jadwal Kuliah', Colors.purple.shade700,
 () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage()))
 ), 
 // 4. KHS
 _buildCompactServiceTile(
 context,
 Icons.receipt_long, 'Lihat KHS', Colors.brown.shade700,
() => Navigator.push(context, MaterialPageRoute(builder: (context) => const KHSPage())) 
),
 ],
 ),
 
const SizedBox(height: 30), 
 // Layanan Administrasi
 const Text('Layanan Administrasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
 ListTile(leading: const Icon(Icons.print, color: Colors.blueGrey), title: const Text('Cetak Dokumen & Transkrip'), trailing: const Icon(Icons.arrow_forward), onTap: () {}),
 ListTile(leading: const Icon(Icons.settings, color: Colors.grey), title: const Text('Pengaturan Aplikasi'), trailing: const Icon(Icons.arrow_forward), onTap: () {}),
 ],
 ),
 ),
 const SizedBox(height: 15),
 ],
 );
 }
}

