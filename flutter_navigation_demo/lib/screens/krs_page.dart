import 'package:flutter/material.dart';

class KRSPage extends StatelessWidget {
  const KRSPage({super.key});

  // Data dummy KRS
  final List<Map<String, String>> krsData = const [
    {'kode': 'MK101', 'mk': 'Algoritma Pemrograman', 'sks': '3', 'semester': 'Ganjil', 'status': 'Pilih'},
    {'kode': 'MK102', 'mk': 'Basis Data', 'sks': '3', 'semester': 'Ganjil', 'status': 'Pilih'},
    {'kode': 'MK103', 'mk': 'Matematika Diskrit', 'sks': '3', 'semester': 'Ganjil', 'status': 'Pilih'},
    {'kode': 'MK104', 'mk': 'Pancasila Kewarganegaraan', 'sks': '2', 'semester': 'Ganjil', 'status': 'Pilih'},
    {'kode': 'MK105', 'mk': 'Logika Informatika', 'sks': '3', 'semester': 'Ganjil', 'status': 'Pilih'},
  ];

  // Widget Header Mahasiswa (Meniru Layout di Gambar)
  Widget buildAcademicHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF001F3F), 
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/logo.png', height: 35, width: 35),
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
              const Icon(Icons.menu, color: Colors.white, size: 28),
            ],
          ),
          const Divider(color: Colors.white38, height: 20),
          const Text('KARTU RENCANA STUDI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Fakultas Sains & Teknologi', style: TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 5),
          _buildStudentInfoRow('Nama        ', 'M. Reno Novriansyah', isDarkBackground: true),
          _buildStudentInfoRow('NIM           ', '701230016', isDarkBackground: true),
          _buildStudentInfoRow('Dosen PA  ', 'Efitra, M.Kom', isDarkBackground: true),
        ],
      ),
    );
  }
  Widget _buildStudentInfoRow(String label, String value, {bool isDarkBackground = false}) {
      Color textColor = isDarkBackground ? Colors.white70 : Colors.white; // Menggunakan warna terang untuk latar belakang gelap
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            SizedBox(width: 80, child: Text('$label:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor))),
            Text(value, style: TextStyle(fontSize: 12, color: textColor)),
          ],
        ),
      );
  }
  // Widget Baris Mata Kuliah (Menggantikan DataTable Row)
  Widget _buildCourseRow(
      String kode, String mk, String sks, String status, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Row(
            children: [
              // Kolom 1: Kode & MK
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kode, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(mk, style: TextStyle(color: Colors.black87, fontSize: 14)),
                  ],
                ),
              ),
              // Kolom 2: SKS
              Expanded(
                flex: 1,
                child: Text(sks, textAlign: TextAlign.center),
              ),
              // Kolom 3: Status & Tombol
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(25), // Warna latar biru muda
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.shade700, width: 0.5),
                  ),
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalSKS = krsData.fold(0, (sum, item) => sum + int.parse(item['sks']!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Rencana Studi (KRS)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF001F3F), 
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Mahasiswa
              buildAcademicHeader(context),
              const Divider(height: 30, thickness: 1.5),

              // Judul Utama
              const Text('KARTU RENCANA STUDI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              // TABS JUDUL (Kode MK, SKS, Status)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Expanded(flex: 4, child: Text('Kode MK / Nama MK', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
                    const Expanded(flex: 1, child: Text('SKS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
                    const Expanded(flex: 2, child: Text('Status', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
                  ],
                ),
              ),
              
              // List Mata Kuliah (Menggunakan ListView.builder di dalam Card)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: krsData.map((data) => 
                    _buildCourseRow(
                      data['kode']!, 
                      data['mk']!, 
                      data['sks']!, 
                      data['status']!, 
                      context
                    )).toList(),
                ),
              ),

              const SizedBox(height: 30),
              
              // Footer Submit KRS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total SKS Diambil: $totalSKS SKS', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('KRS berhasil disimpan! Total SKS: 14'))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('SUBMIT KRS'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
      ),
    );
  }
}