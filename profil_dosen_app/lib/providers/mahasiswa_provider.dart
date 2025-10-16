import 'dart:math';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/dosen_model.dart';

class MahasiswaProvider with ChangeNotifier {
  String? _nama;
  String? _nim;
  String? _jurusan;
  String? _fakultas;
  Dosen? _dosenPembimbing;

  // Getters
  String get nama => _nama ?? 'Nama Mahasiswa';
  String get nim => _nim ?? 'NIM Mahasiswa';
  String get jurusan => _jurusan ?? 'Jurusan Mahasiswa';
  String get fakultas => _fakultas ?? 'Fakultas Mahasiswa';
  Dosen? get dosenPembimbing => _dosenPembimbing;

  // --- SEMUA FUNGSI SEKARANG BERADA DI DALAM KELAS DENGAN BENAR ---

  // Fungsi untuk memproses login
  void login(String namaInput, String nimInput, String jurusanInput, List<Dosen> semuaDosen) {
    _nama = _capitalizeEachWord(namaInput);
    _nim = nimInput;
    _jurusan = jurusanInput;
    _fakultas = _getFakultasFromJurusan(jurusanInput);
    _dosenPembimbing = _getRandomDosenPembimbing(semuaDosen);
    notifyListeners();
  }
  
  // Fungsi untuk mereset data saat logout
  void logout() {
    _nama = null;
    _nim = null;
    _jurusan = null;
    _fakultas = null;
    _dosenPembimbing = null;
  }

  // Helper untuk mencari fakultas berdasarkan jurusan
  String _getFakultasFromJurusan(String jurusan) {
    for (var entry in jurusanPerFakultas.entries) {
      if (entry.value.contains(jurusan)) {
        return entry.key;
      }
    }
    return 'Fakultas Tidak Ditemukan';
  }

  // Helper untuk memilih dosen PA secara acak dari fakultas yang sama
  Dosen? _getRandomDosenPembimbing(List<Dosen> semuaDosen) {
    if (_fakultas == null) return null;
    final dosenSatuFakultas = semuaDosen.where((dosen) => dosen.fakultas == _fakultas).toList();
    if (dosenSatuFakultas.isEmpty) return null;
    final random = Random();
    return dosenSatuFakultas[random.nextInt(dosenSatuFakultas.length)];
  }

  // Helper untuk format nama "Capitalize Each Word"
  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return "";
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
} // <<< PASTIKAN KURUNG KURAWAL PENUTUP KELAS ADA DI SINI