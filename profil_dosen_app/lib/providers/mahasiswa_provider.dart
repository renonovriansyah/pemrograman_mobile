import 'dart:math';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/dosen_model.dart';

class MahasiswaProvider with ChangeNotifier {
  String? _nama;
  String? _nim;
  String? _jenisKelamin;
  String? _jurusan;
  String? _fakultas;
  Dosen? _dosenPembimbing;

  // Getters
  String get nama => _nama ?? 'Nama Mahasiswa';
  String get nim => _nim ?? 'NIM Mahasiswa';
  String get jenisKelamin => _jenisKelamin ?? 'Jenis Kelamin';
  String get jurusan => _jurusan ?? 'Jurusan Mahasiswa';
  String get fakultas => _fakultas ?? 'Fakultas Mahasiswa';
  Dosen? get dosenPembimbing => _dosenPembimbing;

  // --- PERBAIKAN UTAMA DI SINI ---
  // Pastikan fungsi login menerima 5 parameter
  void login(String namaInput, String nimInput, String jenisKelaminInput, String jurusanInput, List<Dosen> semuaDosen) {
    _nama = _capitalizeEachWord(namaInput);
    _nim = nimInput;
    _jenisKelamin = jenisKelaminInput; // Menyimpan jenis kelamin
    _jurusan = jurusanInput;
    _fakultas = _getFakultasFromJurusan(jurusanInput);
    _dosenPembimbing = _getRandomDosenPembimbing(semuaDosen);
    notifyListeners();
  }
  
  void logout() {
    _nama = null;
    _nim = null;
    _jenisKelamin = null; // Reset jenis kelamin
    _jurusan = null;
    _fakultas = null;
    _dosenPembimbing = null;
  }

  // Helper methods...
  String _getFakultasFromJurusan(String jurusan) {
    for (var entry in jurusanPerFakultas.entries) {
      if (entry.value.contains(jurusan)) {
        return entry.key;
      }
    }
    return 'Fakultas Tidak Ditemukan';
  }

  Dosen? _getRandomDosenPembimbing(List<Dosen> semuaDosen) {
    if (_fakultas == null) return null;
    final dosenSatuFakultas = semuaDosen.where((dosen) => dosen.fakultas == _fakultas).toList();
    if (dosenSatuFakultas.isEmpty) return null;
    final random = Random();
    return dosenSatuFakultas[random.nextInt(dosenSatuFakultas.length)];
  }

  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return "";
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}