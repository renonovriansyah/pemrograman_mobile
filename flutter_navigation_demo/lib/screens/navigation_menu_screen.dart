import 'package:flutter/material.dart';
import 'news_detail_page.dart';
import 'event_registration_page.dart';
import 'krs_page.dart';

class NavigationMenuScreen extends StatelessWidget {
  const NavigationMenuScreen({super.key});

  // --- WIDGET PRODI UNGGULAN ---
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
          // Tombol Navigasi (Dibuat vertikal untuk mengisi ruang)
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
  
  // --- WIDGET FOOTER ---
  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFF001F3F), // Warna Biru Tua Gelap
      padding: const EdgeInsets.all(25.0), // Padding sedikit diperbesar
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
                    // Tambahkan Logo/Nama Kampus yang lebih menonjol
                    const Text('UNIVERSITAS BHINNEKA TUNGGAL IKA', 
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 10),
                    const Text('Kampus Teknologi dan Inovasi', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const Text('Jl. Terus Jadian Enggak, Jambi', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 20),
                    // Tambahkan Navigasi Cepat Tambahan
                    const Text('KONTAK', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.white70, size: 16),
                        const SizedBox(width: 5),
                        const Text('info@ubti.ac.id', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ALUMNI', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Karir Alumni', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const Text('Beasiswa', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const Text('Portal Dosen', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white54, height: 40),
          Center(
            child: Text(
              '© ${DateTime.now().year} Universitas Bhinneka Tunggal Ika | All Rights Reserved',
              style: TextStyle(color: Colors.white54, fontSize: 12),
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
              Image.network(
                'https://picsum.photos/800/300?random=1', 
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.black.withAlpha(12), 
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
                      actionLabel1: 'LIHAT KRS', // FUNGSI 1
                      actionLabel2: 'DETAIL PROFIL', // FUNGSI 2
                      imageUrl: 'https://picsum.photos/400/300?random=2',
                      action1: () {
                        // FUNGSI 1: Navigasi Sederhana
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const KRSPage()));
                      },
                      action2: () {
                        // FUNGSI 2: Push & Kirim Data via Route Settings
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
                      actionLabel1: 'CEK PETA KAMPUS', // FUNGSI 3
                      actionLabel2: 'DAFTAR ACARA', // FUNGSI 4
                      imageUrl: 'https://picsum.photos/400/300?random=3',
                      action1: () {
                        // FUNGSI 3: Named Route
                        Navigator.pushNamed(context, '/map', arguments: 'Akses dari Prodi Bisnis');
                      },
                      action2: () async {
                        // FUNGSI 4: Push & Terima Hasil Kembali
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const EventRegistrationPage()));
                        if (result != null && result is Map && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pendaftaran diterima: ${result['nama']}'),
                              backgroundColor: Colors.purple,
                            ),
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
          
          // 4. BERITA & ACARA (Menyematkan Fungsi Navigasi 5)
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
                    subtitle: const Text('Rektor UBTI menyambut lebih dari 3000 mahasiswa baru dengan fokus pada inovasi dan program Kampus Merdeka'),
                    trailing: const Icon(Icons.logout, size: 20, color: Colors.red),
                    onTap: () {
                       // FUNGSI 5: Push Replacement
                       Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const NewsDetailPage()),
                       );
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