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
  
  // Widget Header Akademik Universal (Ditempatkan di level Class)
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
              // Info KHS
       const Text('KARTU HASIL STUDI (KHS)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
 int totalSKS = khsData.fold(0, (sum, item) => sum + int.parse(item['sks']!));
 double totalBobot = khsData.fold(0.0, (sum, item) => sum + double.parse(item['bobot']!));
 double ipSemester = totalBobot / totalSKS;

 return Scaffold(
 appBar: AppBar(
 title: const Text('Kartu Hasil Studi (KHS)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
 backgroundColor: const Color(0xFF001F3F), 
 foregroundColor: Colors.white,
        elevation: 0,
 ),
 body: SingleChildScrollView(
 child: Column( 
 children: [
 // [PANGGILAN HEADER]
 buildAcademicHeader(context), 

 Padding(
 padding: const EdgeInsets.all(20.0),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Text('DETAIL NILAI PER SEMESTER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
 const SizedBox(height: 10),
 
 // Tabel KHS
 Card(
 elevation: 1,
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
 child: Column(
 children: [
 buildKHSHeaderRow(context),
 ...khsData.map((data) => 
 buildKHSDataRow(
 data['kode']!, data['mk']!, data['sks']!, data['nilai']!, context
 )
 ),
 ],
 ),
 ),

 const SizedBox(height: 30),
// Footer IPK
 buildIPSummary(context, totalSKS, ipSemester),
 const SizedBox(height: 50),
 ],
 ),
 ),
 ],
 ),
 ),
 );
 }

  // Widget Baris Header Tabel KHS
 Widget buildKHSHeaderRow(BuildContext context) {
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
 Widget buildKHSDataRow(
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
 Widget buildIPSummary(BuildContext context, int totalSKS, double ipSemester) {
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