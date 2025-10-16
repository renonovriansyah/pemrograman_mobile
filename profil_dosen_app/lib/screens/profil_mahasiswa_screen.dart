import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';

class ProfilMahasiswaScreen extends StatelessWidget {
  const ProfilMahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mahasiswa = Provider.of<MahasiswaProvider>(context);

    return Scaffold(
      // --- PERUBAHAN UI: APPBAR TRANSPARAN ---
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.transparent, // Transparan
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- PERUBAHAN UI: HEADER BARU ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A2647), Color(0xFF205295)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage('https://picsum.photos/seed/mahasiswa123/200/200'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mahasiswa.nama,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  mahasiswa.nim,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
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
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required Map<String, String> data}) {
    // ... (fungsi ini tidak berubah)
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