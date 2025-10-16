import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dosen_list_screen.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';
import '../providers/dosen_provider.dart';
import '../data/dummy_data.dart';

// Mengubah menjadi StatefulWidget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  String? _selectedJurusan;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    // Validasi form
    if (_formKey.currentState!.validate()) {
      // Ambil semua provider (listen: false karena di dalam fungsi)
      final mahasiswaProvider = Provider.of<MahasiswaProvider>(context, listen: false);
      final dosenProvider = Provider.of<DosenProvider>(context, listen: false);
      
      // Panggil fungsi login dari provider
      mahasiswaProvider.login(
        _namaController.text,
        _nimController.text,
        _selectedJurusan!,
        dosenProvider.filteredDosen // Kirim daftar dosen untuk dipilih jadi Dosen PA
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DosenListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final semuaJurusan = jurusanPerFakultas.values.expand((jurusanList) => jurusanList).toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/foto.png', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            // --- PERUBAHAN UI: GRADASI Latar Belakang ---
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withAlpha(77), Colors.black.withAlpha(153)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Image.asset('assets/logo.png', width: 100),
                      const SizedBox(height: 16),
                      Text(
                        'UNIVERSITAS TEKNO MAJU',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [const Shadow(blurRadius: 10, color: Colors.black)],
                        ),
                      ),
                      const SizedBox(height: 60),
                      TextFormField(
                        controller: _namaController,
                        decoration: _buildInputDecoration(label: 'Nama Lengkap', icon: Icons.person_outline),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nimController,
                        decoration: _buildInputDecoration(label: 'NIM (Nomor Induk Mahasiswa)', icon: Icons.badge_outlined),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? 'NIM tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      // ignore: deprecated_member_use_from_same_package
                      DropdownButtonFormField<String>(
                        value: _selectedJurusan,
                        items: semuaJurusan.map((jurusan) => DropdownMenuItem(
                          value: jurusan,
                          child: Text(jurusan),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedJurusan = value;
                          });
                        },
                        decoration: _buildInputDecoration(label: 'Pilih Jurusan Anda', icon: Icons.school_outlined),
                        dropdownColor: Colors.blueGrey[800],
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => value == null ? 'Pilih jurusan Anda' : null,
                      ),
                      const SizedBox(height: 30),
                      // --- PERUBAHAN UI: TOMBOL LEBIH MENARIK ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitLogin,
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text('MASUK', style: TextStyle(fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF205295).withAlpha(230),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Tombol lebih bulat
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}