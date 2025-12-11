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
    return Scaffold(
      // Gradient Background agar lebih aesthetic
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animasi Hero: Ikon ini akan 'terbang' dari halaman sebelumnya jika ada tag yang sama
                  const Hero(
                    tag: 'profile-icon',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.check_circle_outline, size: 60, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  FadeAnimation(
                    delay: 1,
                    child: Text(
                      'Registrasi Berhasil!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Kartu Hasil
                  FadeAnimation(
                    delay: 2,
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Text(jurusan, style: TextStyle(color: Colors.grey.shade600)),
                            const Divider(height: 40),
                            _buildInfoRow(Icons.email, email),
                            _buildInfoRow(Icons.phone, phone),
                            _buildInfoRow(Icons.school, 'Semester ${semester.toInt()}'),
                            const SizedBox(height: 20),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Minat Terpilih:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: hobi.map((h) => Chip(
                                label: Text(h),
                                backgroundColor: Colors.indigo.shade50,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Tombol Kembali
                  FadeAnimation(
                    delay: 3,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('KEMBALI KE HOME'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}