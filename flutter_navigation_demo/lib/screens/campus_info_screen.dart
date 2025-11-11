import 'package:flutter/material.dart';
import 'announcement_tab.dart'; 
import 'services_tab.dart';      

class CampusInfoScreen extends StatelessWidget {
  const CampusInfoScreen({super.key});

  // --- WIDGET HEADER INFORMASI (Gaya Seragam) ---
  // lib/screens/campus_info_screen.dart (Widget _buildInfoHeader)

Widget buildInfoHeader(BuildContext context) {
    return Container(
        width: double.infinity,
        color: const Color(0xFF001F3F), 
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0, right: 20.0), 
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // [PERBAIKAN]: Rata kiri untuk semua konten
            children: [
                // 1. Logo Universitas (Rata Kiri)
                Row(
                    children: [
                        Image.asset('assets/logo.png', height: 40, width: 40),
                        const SizedBox(width: 10),
                        const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('UNIVERSITAS', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                Text('BHINNEKA TUNGGAL IKA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                        ),
                    ],
                ),
                
                // 2. Garis Pemisah
                // [PERBAIKAN]: Menggunakan Container yang stabil sebagai pemisah
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    height: 1,
                    color: Colors.white38,
                ),

                // 3. Judul Halaman
                const Text(
                    'Informasi Kampus',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                    'Pengumuman dan Layanan Cepat',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
            ],
        ),
    );
}
  
  // --- WIDGET FOOTER HELPERS (Wajib ada di Class ini) ---
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

  Widget buildDrawerContent(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.school, size: 40, color: Color(0xFF001F3F))),
                SizedBox(height: 10),
                Text('Portal Menu Akademik', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Akses Peta Kampus (/map)'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, '/map', arguments: 'Akses dari Drawer Profil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/'); 
            },
          ),
        ],
      ),
    );
  }
  
  // Widget Pembantu untuk Menempelkan Footer di Setiap Tab
  Widget buildTabContentWithFooter(BuildContext context, Widget tabContent) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Konten Tab (Pengumuman / Layanan)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: tabContent,
          ),
          
          _buildFooter(context), // Panggil footer di akhir konten tab
        ],
      ),
    );
  }
  
  // --- END OF HELPERS ---

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold( 
        // [PERBAIKAN FOKUS]: Menetapkan AppBar ke warna Konsisten
        appBar: AppBar( 
          title: const Text('Info Kampus', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF001F3F), // Warna Konsisten
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar( 
            tabs: [
              Tab(icon: Icon(Icons.campaign), text: 'Pengumuman'),
              Tab(icon: Icon(Icons.miscellaneous_services), text: 'Layanan Cepat'),
            ],
            labelColor: Colors.white, // Agar teks Tab terlihat di AppBar gelap
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        drawer: buildDrawerContent(context),
        // [PERBAIKAN]: Body hanya perlu menampilkan TabBarView
        body: TabBarView(
          children: [
            buildTabContentWithFooter(context, const AnnouncementTab()),
            buildTabContentWithFooter(context, const ServicesTab()),
          ],
        ),
      ),
    );
  }
}