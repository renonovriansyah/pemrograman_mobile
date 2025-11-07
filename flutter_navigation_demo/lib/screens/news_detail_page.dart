import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget { // Nama class tetap AcademicCalendarPage
  const NewsDetailPage ({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Random yang terlihat nyata
    const String namaKampus = 'Universitas Panca Bhakti';
    const String namaRektor = 'Prof. Dr. Ir. Candra Kirana, M.T.';
    const String lokasiAcara = 'Gedung Serbaguna Kampus Induk';
    const String jumlahMaba = '3.150';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita Kampus'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
            children: [
              Image.asset('assets/logo.png', height: 40, width: 40),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BERITA RESMI', style: TextStyle(fontSize: 12)),
                  Text('UNIVERSITAS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
            // Konten Gambar Berita
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://picsum.photos/800/400?random=5', // Gambar yang lebih besar
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Judul Berita
            const Text(
              'Rektor Sambut Mahasiswa Baru, Semangat Kampus Merdeka Wujudkan Inovasi!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Rilis: 25 Agustus 2025 | Oleh: Humas $namaKampus',
              style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const Divider(height: 30),

            // Isi Berita - Paragraf 1
            Text(
              'JAMBI – $namaRektor, Rektor $namaKampus, secara resmi membuka kegiatan Orientasi Studi dan Pengenalan Kampus (OSPEK) tahun akademik 2025/2026. Acara penyambutan yang meriah ini diadakan di $lokasiAcara dan dihadiri oleh jajaran dekanat, dosen, dan perwakilan alumni. Total $jumlahMaba mahasiswa baru resmi bergabung dengan keluarga besar UBTI.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 15),

            // Isi Berita - Paragraf 2 (Kutipan Rektor)
            Text(
              'Dalam pidato sambutannya yang penuh semangat, $namaRektor menekankan bahwa generasi muda adalah kunci masa depan bangsa. "Kami berkomitmen penuh untuk mendukung program Kampus Merdeka. Kami ingin mahasiswa tidak hanya unggul secara teori, tetapi juga mampu mengimplementasikan ilmunya di lapangan. Gunakan fasilitas dan sistem navigasi akademik yang canggih yang telah kami siapkan di portal ini," tuturnya.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 15),

            // Isi Berita - Paragraf 3 (Detail Acara)
            Text(
              'Salah satu fokus utama dalam OSPEK tahun ini adalah pengenalan lingkungan digital kampus dan portal akademik. Mahasiswa diajarkan cara menggunakan **sistem navigasi** untuk KRS, melihat jadwal kuliah, dan mengakses perpustakaan digital. Kegiatan ini dipimpin langsung oleh Kepala Pusat Data dan Informasi, **Dr. Sinta Dewi, M.Kom.**, yang memastikan semua mahasiswa siap menghadapi perkuliahan digital.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 15),
            
            // Isi Berita - Paragraf 4 (Penutup)
            Text(
              'Acara ditutup dengan penampilan kreatif dari Unit Kegiatan Mahasiswa (UKM), menunjukkan bahwa kehidupan kampus tidak hanya diisi dengan kegiatan akademik, tetapi juga pengembangan bakat dan minat. Rangkaian OSPEK akan berlanjut selama tiga hari ke depan.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            
            const SizedBox(height: 30),

          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/', // Rute target: MainCampusScreen
                  (Route<dynamic> route) => false,
              );
              },
              icon: const Icon(Icons.home), // Mengganti ikon
              label: const Text('Kembali ke Menu Utama'), // Mengganti label
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}