import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dosen_list_screen.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/mahasiswa_provider.dart';
import '../providers/dosen_provider.dart';
import '../data/dummy_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  String? _selectedJurusan;
  String? _selectedJenisKelamin;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    bool isGenderSelected = _selectedJenisKelamin != null;
    if (_formKey.currentState!.validate() && isGenderSelected) {
      final mahasiswaProvider = Provider.of<MahasiswaProvider>(context, listen: false);
      final dosenProvider = Provider.of<DosenProvider>(context, listen: false);
      
      mahasiswaProvider.login(
        _namaController.text,
        _nimController.text,
        _selectedJenisKelamin!,
        _selectedJurusan!,
        dosenProvider.filteredDosen
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DosenListScreen()),
      );
    } else if (!isGenderSelected) {
      setState(() {});
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Center(child: Image.asset('assets/logo.png', width: 100)),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'UNIVERSITAS TEKNO MAJU',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [const Shadow(blurRadius: 10, color: Colors.black)],
                          ),
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

                      // --- PERUBAHAN URUTAN DI SINI ---
                      
                      // 1. Jurusan sekarang di atas
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
                      const SizedBox(height: 16),
                      
                      // 2. Jenis Kelamin sekarang di bawah
                      const Text('Jenis Kelamin', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      Row(
                        children: [
                          Expanded(
                            // ignore: deprecated_member_use_from_same_package
                            child: RadioListTile<String>(
                              title: const Text('Laki-laki', style: TextStyle(color: Colors.white)),
                              value: 'Laki-laki',
                              groupValue: _selectedJenisKelamin,
                              onChanged: (value) {
                                setState(() { _selectedJenisKelamin = value; });
                              },
                              activeColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            // ignore: deprecated_member_use_from_same_package
                            child: RadioListTile<String>(
                              title: const Text('Perempuan', style: TextStyle(color: Colors.white)),
                              value: 'Perempuan',
                              groupValue: _selectedJenisKelamin,
                              onChanged: (value) {
                                setState(() { _selectedJenisKelamin = value; });
                              },
                              activeColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      if (_formKey.currentState?.validate() == false && _selectedJenisKelamin == null)
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Pilih jenis kelamin Anda',
                            style: TextStyle(color: Color(0xffcf6679), fontSize: 12),
                          ),
                        ),
                      
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitLogin,
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text('MASUK', style: TextStyle(fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF205295).withAlpha(230),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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