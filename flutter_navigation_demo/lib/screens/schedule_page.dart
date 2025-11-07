import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  final List<Map<String, String>> scheduleData = const [
    {'kode': 'AL101', 'mk': 'Algoritma Pemrograman', 'sks': '3', 'hari': 'Senin', 'jam': '08:00 - 10:30', 'ruangan': 'R.A.201', 'dosen': 'Dr. Budi Santoso'},
    {'kode': 'MT201', 'mk': 'Matematika Diskrit', 'sks': '3', 'hari': 'Rabu', 'jam': '10:30 - 12:00', 'ruangan': 'R.B.102', 'dosen': 'Dr. Ruth Hriyanso'},
    {'kode': 'PK303', 'mk': 'Pancasila & Kewarganegaraan', 'sks': '2', 'hari': 'Kamis', 'jam': '13:30 - 15:00', 'ruangan': 'Lt.3.Lab.A', 'dosen': 'Dst. Doni Seflawan'},
  ];

  // Widget Header Akademik Universal (Diperbarui untuk Jadwal)
  Widget _buildAcademicHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF001F3F), // Warna Biru Tua
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
              const Icon(Icons.menu, color: Colors.white, size: 28), // Ikon Menu Hamburger
            ],
          ),
          const Divider(color: Colors.white38, height: 20),
          // Info Mahasiswa di bawah Header
          const Text('JADWAL KULIAH SEMESTER GENAP 2024/2025', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Jadwal Kuliah', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER AKADEMIK UNIVERSAL
            _buildAcademicHeader(context),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabel Jadwal (Menggunakan DataTable untuk Struktur Rapi)
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        horizontalMargin: 10,
                        headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.grey.shade100),
                        dataRowMinHeight: 40,
                        columns: const [
                          DataColumn(label: Text('KODE MK', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('MATA KULIAH', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('SKS', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('HARI', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('JAM', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('RUANGAN', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('DOSEN PENGAMPU', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: scheduleData.map((data) => DataRow(
                          cells: [
                            DataCell(Text(data['kode']!)),
                            DataCell(Text(data['mk']!)),
                            DataCell(Text(data['sks']!)),
                            DataCell(Text(data['hari']!)),
                            DataCell(Text(data['jam']!)),
                            DataCell(Text(data['ruangan']!)),
                            DataCell(Text(data['dosen']!, style: TextStyle(fontSize: 13))),
                          ],
                        )).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  // Tombol Cetak Jadwal
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jadwal sedang dipersiapkan untuk dicetak!'))
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: const Text('CETAK JADWAL'),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}