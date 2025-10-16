import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';
import 'dart:ui'; // Diperlukan untuk efek blur (ImageFilter)

class ProfilMahasiswaScreen extends StatelessWidget {
  const ProfilMahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mahasiswa = Provider.of<MahasiswaProvider>(context);

    // Logika untuk memilih path foto profil yang benar
    String fotoProfilPath;
    if (mahasiswa.jenisKelamin == 'Laki-laki') {
      fotoProfilPath = 'assets/mahasiswapria.png';
    } else { // Jika perempuan
      if (mahasiswa.fakultas == 'Syariah') {
        fotoProfilPath = 'assets/mahasiswahijab.png';
      } else {
        fotoProfilPath = 'assets/mahasiswawanita.png';
      }
    }

    return Scaffold(
      // Body sekarang menggunakan CustomScrollView
      body: CustomScrollView(
        slivers: [
          // AppBar dinamis yang bisa membesar dan mengecil
          SliverAppBar(
            expandedHeight: 300.0, // Memberi ruang lebih untuk header
            floating: false,
            pinned: true, // AppBar akan tetap terlihat saat di-scroll
            backgroundColor: const Color(0xFF0A2647),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mahasiswa.nama,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 48, right: 48, bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar latar belakang yang diburamkan
                  Image.asset(
                    fotoProfilPath,
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      color: Colors.black.withAlpha(102), // Opacity 0.4
                    ),
                  ),
                  // Konten header (foto, jenis kelamin, NIM)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20), // Penyesuaian jarak dari atas
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 52,
                            backgroundImage: AssetImage(fotoProfilPath),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Nama sekarang menjadi judul, jadi kita tampilkan sisanya di sini
                        Text(
                          mahasiswa.jenisKelamin,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mahasiswa.nim,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sisa konten halaman (kartu informasi)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: 'Data Akademik',
                    icon: Icons.school,
                    data: {
                      'Fakultas': mahasiswa.fakultas,
                      'Jurusan': mahasiswa.jurusan,
                      'Dosen PA': mahasiswa.dosenPembimbing?.nama ?? 'Belum Ditentukan',
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper ini tidak perlu diubah
  Widget _buildInfoCard({required String title, required IconData icon, required Map<String, String> data}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20),
            ...data.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: Text(e.key, style: const TextStyle(color: Colors.grey))),
                  const Text(' :  '),
                  Expanded(flex: 3, child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}