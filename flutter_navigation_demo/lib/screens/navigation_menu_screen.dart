import 'package:flutter/material.dart';
import 'krs_page.dart';
import 'event_registration_page.dart';
import 'news_detail_page.dart';

class NavigationMenuScreen extends StatelessWidget {
  const NavigationMenuScreen({super.key});

  // Widget Kustom untuk Tombol Navigasi
  Widget buildNavActionLink(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),
    );
  }

  // --- WIDGET PRODI UNGGULAN CARD ---
  Widget _buildProdiCard(
    BuildContext context, {
    required String title,
    required String actionLabel1,
    required String actionLabel2,
    required VoidCallback action1,
    required VoidCallback action2,
    required String imageUrl,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              height: 120, 
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: action1,
                  style: TextButton.styleFrom(minimumSize: const Size.fromHeight(30)),
                  child: Text(actionLabel1, style: const TextStyle(fontSize: 12, color: Colors.blue)),
                ),
                TextButton(
                  onPressed: action2,
                  style: TextButton.styleFrom(minimumSize: const Size.fromHeight(30)),
                  child: Text(actionLabel2, style: const TextStyle(fontSize: 12, color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET PEMBANTU FOOTER ---
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

  // --- WIDGET FOOTER UTAMA ---
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER BANNER BESAR
          Stack(
            children: [
              Image.network('https://picsum.photos/800/300?random=1', height: 250, width: double.infinity, fit: BoxFit.cover),
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.black.withAlpha(14), 
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(left: 20, bottom: 30),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EMPOWERING MINDS,', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('SHAPING THE FUTURE.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),

          // 2. BAGIAN PRODI UNGGULAN
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRODI UNGGULAN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const Divider(thickness: 2, endIndent: 200),
                
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.9, 
                  children: [
                    // CARD 1: TEKNIK INFORMATIKA
                    _buildProdiCard(
                      context,
                      title: 'Teknik Informatika',
                      actionLabel1: 'LIHAT KRS (PUSH)',
                      actionLabel2: 'DETAIL PROFIL (PUSH & DATA)',
                      imageUrl: 'https://picsum.photos/400/300?random=2',
                      action1: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const KRSPage()));
                      },
                      action2: () {
                        Navigator.pushNamed(
                          context, 
                          '/detail',
                          arguments: {'nama': 'Budi Santoso', 'npm': '20210001', 'jurusan': 'TI'},
                        );
                      },
                    ),

                    // CARD 2: MANAJEMEN BISNIS
                    _buildProdiCard(
                      context,
                      title: 'Manajemen Bisnis',
                      actionLabel1: 'CEK PETA KAMPUS (NAMED ROUTE)',
                      actionLabel2: 'DAFTAR ACARA (POP RESULT)',
                      imageUrl: 'https://picsum.photos/400/300?random=3',
                      action1: () {
                        Navigator.pushNamed(context, '/map', arguments: 'Akses dari Prodi Bisnis');
                      },
                      action2: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EventRegistrationPage()));
                        if (result != null && result is Map && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pendaftaran diterima: ${result['nama']}'), backgroundColor: Colors.purple),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 3. TESTIMONI DAN FAKTA & ANGKA
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: Colors.grey.shade50, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TESTIMONI ALUMNI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const Divider(thickness: 2, endIndent: 150),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=10'), radius: 25),
                            const SizedBox(width: 10),
                            Text('Ryan T., Lulusan 2018', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '"Kualitas pengajaran dan fasilitas di kampus sangat luar biasa. Ini bukan hanya tempat belajar, tapi tempat membentuk masa depan!"',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 4. BERITA & ACARA
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BERITA & PENGUMUMAN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const Divider(thickness: 2, endIndent: 200),
                
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network('https://picsum.photos/100/100?random=4', width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: const Text('Rektor Sambut Mahasiswa Baru, Semangat Kampus Merdeka!', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Rektor UBTI menyambut lebih dari 3000 mahasiswa baru dengan fokus pada inovasi dan program Kampus Merdeka.'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue),
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsDetailPage()));
                    },
                  ),
                ),
              ],
            ),
          ),

          // 5. FOOTER RESMI KAMPUS
          _buildFooter(context),
        ],
      ),
    );
  }
}