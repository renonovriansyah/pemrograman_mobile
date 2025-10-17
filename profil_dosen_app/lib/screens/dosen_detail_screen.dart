import 'package:flutter/material.dart';
import '../models/dosen_model.dart';
import 'dart:ui';

class DosenDetailScreen extends StatelessWidget {
  final Dosen dosen;
  const DosenDetailScreen({super.key, required this.dosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0A2647),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              title: Text(
                dosen.nama,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Latar Belakang menggunakan AssetImage
                  Image.asset(
                    dosen.fotoUrl,
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withAlpha(77), // Opacity 0.3
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 67,
                        // Foto profil utama menggunakan AssetImage
                        backgroundImage: AssetImage(dosen.fotoUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NIP: ${dosen.nip}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 24),
                  _buildInfoCard('Data Pribadi', {
                    'Tempat/Tanggal Lahir': '${dosen.tempatLahir}, ${dosen.tanggalLahir}',
                    'Jenis Kelamin': dosen.jenisKelamin,
                    'Agama': dosen.agama,
                    'Alamat Email': dosen.email,
                  }),
                  const SizedBox(height: 16),
                  _buildInfoCard('Data Akademik', {
                    'Fakultas': dosen.fakultas,
                    'Jurusan': dosen.jurusan,
                    'Jabatan Akademik': dosen.jabatanAkademik,
                    'Golongan/Pangkat': dosen.golonganPangkat,
                    'Status': dosen.status,
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, Map<String, String> data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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