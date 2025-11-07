import 'package:flutter/material.dart';

class KHSPage extends StatelessWidget {
  const KHSPage({super.key});

  // Data dummy KHS
  final List<Map<String, String>> khsData = const [
    {'kode': 'MK101', 'mk': 'Algoritma Pemrograman', 'sks': '3', 'nilai': 'A', 'bobot': '12.0'},
    {'kode': 'MK102', 'mk': 'Basis Data', 'sks': '3', 'nilai': 'B+', 'bobot': '10.5'},
    {'kode': 'MK103', 'mk': 'Matematika Diskrit', 'sks': '3', 'nilai': 'A-', 'bobot': '11.1'},
    {'kode': 'MK104', 'mk': 'Pancasila Kewarganegaraan', 'sks': '2', 'nilai': 'A', 'bobot': '8.0'},
    {'kode': 'MK105', 'mk': 'Logika Informatika', 'sks': '3', 'nilai': 'B', 'bobot': '9.0'},
  ];

  @override
  Widget build(BuildContext context) {
    int totalSKS = khsData.fold(0, (sum, item) => sum + int.parse(item['sks']!));
    double totalBobot = khsData.fold(0.0, (sum, item) => sum + double.parse(item['bobot']!));
    double ipSemester = totalBobot / totalSKS;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Hasil Studi (KHS)'),
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

              // Tabel KHS
              const Text('DETAIL NILAI PER SEMESTER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    // Header Tabel KHS
                    _buildKHSHeaderRow(context),
                    // List Nilai
                    ...khsData.map((data) => 
                      _buildKHSDataRow(
                        data['kode']!, 
                        data['mk']!, 
                        data['sks']!, 
                        data['nilai']!, 
                        context
                      )
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
              
              // Footer IPK
              _buildIPSummary(context, totalSKS, ipSemester),
              
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Header Mahasiswa (dengan foto dan info dasar)
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
                const Text('Kartu Hasil Studi', style: TextStyle(fontSize: 14, color: Colors.black54)),
                const Text('Nama: Jessica Tania', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('NIM: 20210045', style: TextStyle(fontSize: 14, color: Colors.black87)),
                Text('Semester: Ganjil 2024/2025', style: TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Baris Header Tabel KHS
  Widget _buildKHSHeaderRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 4, child: Text('Kode MK / Nama MK', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
          Expanded(flex: 1, child: Text('SKS', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
          Expanded(flex: 1, child: Text('Nilai', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
        ],
      ),
    );
  }
  
  // Widget Baris Data KHS (Menggantikan DataTable Row)
  Widget _buildKHSDataRow(
      String kode, String mk, String sks, String nilai, BuildContext context) {
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
              // Kolom 3: Nilai
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getNilaiColor(nilai).withAlpha(25), // Warna latar
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    nilai,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _getNilaiColor(nilai), fontSize: 14, fontWeight: FontWeight.bold),
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

  // Helper untuk mendapatkan warna berdasarkan nilai
  Color _getNilaiColor(String nilai) {
    if (nilai == 'A' || nilai == 'A-' || nilai == 'B+') return Colors.green.shade700;
    if (nilai == 'B' || nilai == 'B-') return Colors.blue.shade700;
    if (nilai == 'C' || nilai == 'D') return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  // Widget Summary IPK
  Widget _buildIPSummary(BuildContext context, int totalSKS, double ipSemester) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Indeks Prestasi Semester (IPS)', style: TextStyle(fontSize: 14, color: Colors.black54)),
                Text(ipSemester.toStringAsFixed(2), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Total SKS: $totalSKS', style: const TextStyle(fontSize: 14)),
                const Text('Status: Lulus Semester', style: TextStyle(fontSize: 14, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}