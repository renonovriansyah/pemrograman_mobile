import 'package:flutter/material.dart';

class UKTPage extends StatelessWidget {
  const UKTPage({super.key});

  // Data dummy Tagihan UKT
  final List<Map<String, String>> uktData = const [
    {'deskripsi': 'UKT Pokok', 'idr': '5.100.000', 'semester': 'Genap', 'status': 'Paid'},
    {'deskripsi': 'Sumbangan Pengembangan Institusi (SPI)', 'idr': '3.980.000', 'semester': 'Pilih', 'status': 'Pilih'},
    {'deskripsi': 'Cicilan Cicilan', 'idr': '2.100.000', 'semester': 'Pilih', 'status': 'Pilih'},
    {'deskripsi': 'Biaya Kemahasiswaan', 'idr': '250.000', 'semester': 'Pilih', 'status': 'Pilih'},
  ];

  // [UNIVERSAL HEADER] - Perbaikan 1: Pastikan dideklarasikan di level class
  Widget _buildAcademicHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF001F3F), 
      padding: const EdgeInsets.all(20.0),
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
                      Text('UNIVERSITAS', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Text('BHINNEKA TUNGGAL IKA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.menu, color: Colors.white, size: 28),
            ],
          ),
          const Divider(color: Colors.white38, height: 20),
          
          // Info Tagihan
          const Text('TAGIHAN UKT SEMESTER GENAP 2024/2025', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('Fakultas Sains & Teknologi', style: TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 10),
          
          // Info Mahasiswa (Teks Putih)
          _buildStudentInfoRow('Nama        ', 'M. Reno Novriansyah', isDarkBackground: true),
          _buildStudentInfoRow('NIM           ', '701230016', isDarkBackground: true),
          _buildStudentInfoRow('Dosen PA  ', 'Efitra, M.Kom', isDarkBackground: true),
        ],
      ),
    );
  }

  // [WIDGET HELPER] - Perbaikan 2: Tambahkan parameter isDarkBackground di definisi
  Widget _buildStudentInfoRow(String label, String value, {bool isDarkBackground = false}) {
      Color textColor = isDarkBackground ? Colors.white70 : Colors.black87;
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

  // ... (Method _buildTagihanTable, _buildTableHeader, _buildDataRow, _buildStatusButton, _buildPaymentFooter)
  // ... (Sisanya harus ada di sini di level class, seperti yang Anda kirimkan sebelumnya)
  
  // Widget Tabel Tagihan (Ditempatkan di sini di level Class)
  Widget _buildTagihanTable(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          _buildTableHeader(),
          ...uktData.map((data) => _buildDataRow(
            data['deskripsi']!,
            data['idr']!,
            data['semester']!,
            data['status']!,
          )),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 4, child: Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('IDR', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
          Expanded(flex: 1, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildDataRow(String deskripsi, String idr, String semester, String status) {
    bool isTotal = deskripsi.contains('Biaya Kemahasiswaan');
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        color: isTotal ? Colors.yellow.shade50 : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              deskripsi, 
              style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              idr, 
              style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal), 
              textAlign: TextAlign.end
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: _buildStatusButton(status)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    Color color = Colors.grey.shade500;
    if (status == 'Paid') color = Colors.green.shade700;
    if (status == 'Pilih') color = Colors.blue.shade700;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPaymentFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengalihkan ke Portal Pembayaran...'))
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('BAYAR SEKARANG'),
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Batas Pembayaran: 31 Maret 2026', 
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F), 
        foregroundColor: Colors.white,
        title: const Text('Tagihan UKT Semester Genap 2024/2025', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Logo & Tagihan (Sekarang Full Biru Navy)
            _buildAcademicHeader(context),
            
            // Tabel Tagihan
            _buildTagihanTable(context),

            // Footer Pembayaran dan Batas Waktu
            _buildPaymentFooter(context),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}