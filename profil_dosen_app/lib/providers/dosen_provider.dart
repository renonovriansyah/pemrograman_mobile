import 'package:flutter/material.dart';
import '../models/dosen_model.dart';
import '../data/dummy_data.dart';

class DosenProvider with ChangeNotifier {
  final List<Dosen> _allDosen = generateDummyDosen();
  List<Dosen> _filteredDosen = [];

  // Variabel untuk jurusan sudah dihapus
  String? _selectedFakultas;
  String? _selectedStatus;
  String _searchQuery = '';

  DosenProvider() {
    _filteredDosen = _allDosen;
  }

  // Getters
  List<Dosen> get filteredDosen => _filteredDosen;
  String? get selectedFakultas => _selectedFakultas;
  String? get selectedStatus => _selectedStatus;

  // Getter untuk jurusan sudah dihapus
  List<String> get allFakultas => jurusanPerFakultas.keys.toList();
  List<String> get allStatus => _allDosen.map((d) => d.status).toSet().toList();

  // Filter Logic
  void _applyFilters() {
    List<Dosen> tempDosen = _allDosen;

    if (_searchQuery.isNotEmpty) {
      tempDosen = tempDosen.where((dosen) =>
          dosen.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dosen.nip.contains(_searchQuery)).toList();
    }
    if (_selectedFakultas != null) {
      tempDosen = tempDosen.where((dosen) => dosen.fakultas == _selectedFakultas).toList();
    }
    // Blok if untuk jurusan sudah dihapus
    if (_selectedStatus != null) {
      tempDosen = tempDosen.where((dosen) => dosen.status == _selectedStatus).toList();
    }

    _filteredDosen = tempDosen;
    notifyListeners();
  }

  // Update Methods
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFakultas(String? fakultas) {
    _selectedFakultas = fakultas;
    _applyFilters();
  }

  // Fungsi setJurusan() sudah dihapus
  void setStatus(String? status) {
    _selectedStatus = status;
    _applyFilters();
  }

  void clearFilters() {
    _selectedFakultas = null;
    _selectedStatus = null;
    _searchQuery = '';
    _applyFilters();
  }
}