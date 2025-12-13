import 'package:flutter/material.dart';
import '../widgets/fade_animation.dart';

class ResultPage extends StatelessWidget {
  final String nama;
  final String email;
  final String phone;
  final String jurusan;
  final double semester;
  final List<String> hobi;

  const ResultPage({
    super.key,
    required this.nama,
    required this.email,
    required this.phone,
    required this.jurusan,
    required this.semester,
    required this.hobi,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil inisial nama untuk avatar
    String initials = nama.isNotEmpty 
        ? nama.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase() 
        : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Background soft
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATION (Header Gradient)
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4F46E5), // Indigo
                  Color(0xFF0EA5E9), // Sky Blue
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),

          // 2. CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // ICON SUKSES (ANIMATED)
                  const Hero(
                    tag: 'profile-icon', // Tag ini harus sama dengan icon di halaman sebelumnya jika ingin efek terbang
                    child: FadeAnimation(
                      delay: 0.5,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.check_rounded, size: 50, color: Color(0xFF0EA5E9)),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  FadeAnimation(
                    delay: 0.8,
                    child: const Text(
                      'Registrasi Berhasil!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  FadeAnimation(
                    delay: 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(78), // Efek kaca transparan
                        borderRadius: BorderRadius.circular(20), // Sudut membulat (Pill shape)
                        border: Border.all(color: Colors.white.withAlpha(56)), // Garis tepi tipis
                      ),
                      child: Text(
                        'Data Anda telah tersimpan di sistem.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withAlpha(92), // Putih sedikit soft
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5, // Spasi antar huruf biar rapi
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 3. DIGITAL ID CARD
                  FadeAnimation(
                    delay: 1.2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(19),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header Kartu
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: const Color(0xFF4F46E5),
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nama,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0E7FF),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          jurusan,
                                          style: const TextStyle(
                                            color: Color(0xFF4F46E5),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                          // Body Kartu (Detail Info)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                _buildDetailItem(Icons.email_outlined, 'Email', email),
                                _buildDetailItem(Icons.phone_outlined, 'Telepon', phone),
                                _buildDetailItem(Icons.calendar_today_outlined, 'Semester', 'Semester ${semester.toInt()}'),
                                
                                const SizedBox(height: 24),
                                
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Minat & Hobi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: hobi.map((h) => Chip(
                                      label: Text(h),
                                      labelStyle: const TextStyle(
                                        color: Color(0xFF4F46E5), 
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12
                                      ),
                                      backgroundColor: const Color(0xFFEEF2FF), // Very light indigo
                                      side: const BorderSide(color: Color(0xFFC7D2FE)), // Soft border
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      visualDensity: VisualDensity.compact,
                                    )).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Footer Kartu (Barcode Fake) 
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                              border: Border(top: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: Center(
                              child: Text(
                                'ID: ${DateTime.now().millisecondsSinceEpoch}',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  letterSpacing: 2,
                                  fontFamily: 'Courier', // Font monospaced ala tiket
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 4. TOMBOL KEMBALI
                  FadeAnimation(
                    delay: 1.5,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFF4F46E5).withAlpha(15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'KEMBALI KE BERANDA',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Baris Data
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}