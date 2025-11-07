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
  Widget _buildStudentHeader(BuildContext context) {
    return Card(
      // ... styling
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // Ubah Row utama menjadi Column untuk menampung Logo Header dan Info Mahasiswa
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INTEGRASI LOGO HEADER
            Row( 
              children: [
                Image.asset('assets/logo.png', height: 40, width: 40), // Pastikan asset terdaftar!
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UNIVERSITAS', style: TextStyle(fontSize: 12)),
                    Text('BHINNEKA TUNGGAL IKA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5),
        
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=15'), 
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hayyan Tanwir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('NIM: 20210045 - Teknik Informatika', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                Text('Dosen Wali: Dr. Rina M.Kom', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ],
        ),
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
        title: const Text('Kartu Rencana Studi (KRS)'),
        backgroundColor: const Color(0xFF001F3F), 
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Mahasiswa
              _buildStudentHeader(context),
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
      ),
    );
  }
}