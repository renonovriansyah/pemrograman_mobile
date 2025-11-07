import 'package:flutter/material.dart';
import 'announcement_tab.dart'; 
import 'services_tab.dart';      

class CampusInfoScreen extends StatelessWidget {
  const CampusInfoScreen({super.key});

  // --- WIDGET PEMBANTU FOOTER --- (Salin dari ProfileScreen)
  Widget _buildContactRow(IconData icon, String text) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Icon(icon, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13))),
              ],
          ),
      );
  }

  Widget _buildSocialMediaRow() {
      return Row(
          children: [
              IconButton(icon: const Icon(Icons.facebook, color: Colors.white, size: 24), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share, color: Colors.white, size: 24), onPressed: () {}), 
              IconButton(icon: const Icon(Icons.ondemand_video, color: Colors.white, size: 24), onPressed: () {}), 
          ],
      );
  }
  
  // --- WIDGET FOOTER UTAMA --- (Salin dari ProfileScreen)
  Widget _buildFooter(BuildContext context) {
      final List<Map<String, String>> quickLinks = [
        {'label': 'Home / Beranda', 'route': '/'},
        {'label': 'Info Kampus', 'route': '/info'},
        {'label': 'Profil Mahasiswa', 'route': '/profile'},
        {'label': 'Peta Kampus', 'route': '/map'},
        {'label': 'KRS', 'route': '/krs'}, 
      ];

      return Container(
        color: const Color(0xFF001F3F), 
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/logo.png', height: 50, width: 50),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('UNIVERSITAS', style: TextStyle(color: Colors.white, fontSize: 14)),
                              Text('BHINNEKA TUNGGAL IKA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Mencetak Generasi Unggul untuk Indonesia Maju', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TAUTAN CEPAT', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...quickLinks.map((link) => Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(link['label']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('HUBUNGI KAMI', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildContactRow(Icons.location_on, 'Jl. Persatuan No. 1, Jambi'),
                      _buildContactRow(Icons.phone, '(+62) 21 1234 5678'),
                      const SizedBox(height: 15),
                      const Text('IKUTI KAMI', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildSocialMediaRow(),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white54, height: 40),
            Center(
              child: Text(
                '© ${DateTime.now().year} Universitas Bhinneka Tunggal Ika. All Rights Reserved.',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            )
          ],
        ),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold( 
        appBar: AppBar( 
          title: const Text('Info Kampus'),
          bottom: const TabBar( 
            tabs: [
              Tab(icon: Icon(Icons.campaign), text: 'Pengumuman'),
              Tab(icon: Icon(Icons.miscellaneous_services), text: 'Layanan Cepat'),
            ],
            labelColor: Color(0xFF001F3F),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF001F3F),
          ),
        ),
        
        body: TabBarView(
          children: [
            // Konten Tab kini harus menyertakan footer di dalamnya
            // AnnouncementTab dan ServicesTab HARUS diubah agar memiliki SingleChildScrollView di dalamnya
            _buildTabContentWithFooter(context, const AnnouncementTab()),
            _buildTabContentWithFooter(context, const ServicesTab()),
          ],
        ),
      ),
    );
  }
  
  // Widget Pembantu untuk Menempelkan Footer di Setiap Tab
  Widget _buildTabContentWithFooter(BuildContext context, Widget tabContent) {
    return SingleChildScrollView(
      child: Column(
        children: [
          tabContent,
          _buildFooter(context), // Panggil footer di akhir konten tab
        ],
      ),
    );
  }
}