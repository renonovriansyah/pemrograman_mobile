import 'package:flutter/material.dart';
import 'announcement_tab.dart'; // Import tab baru
import 'services_tab.dart';      // Import tab baru

class CampusInfoScreen extends StatelessWidget {
  const CampusInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan DefaultTabController untuk mengimplementasikan Tab Bar
    return const DefaultTabController(
      length: 2, // Jumlah tab yang digunakan
      child: Scaffold(
        // AppBar diganti dengan Tab Bar (Tab Bar diletakkan di bawah AppBar utama)
        appBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.campaign), text: 'Pengumuman'),
            Tab(icon: Icon(Icons.miscellaneous_services), text: 'Layanan Cepat'),
          ],
          labelColor: Color(0xFF001F3F),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF001F3F),
        ),
        
        body: TabBarView(
          children: [
            // Konten Tab 1
            AnnouncementTab(), 
            // Konten Tab 2
            ServicesTab(),
          ],
        ),
      ),
    );
  }
}