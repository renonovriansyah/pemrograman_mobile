import 'dart:convert'; // Untuk jsonEncode dan jsonDecode
import 'package:shared_preferences/shared_preferences.dart';
import 'note_model.dart';

class StorageService {
  // Key untuk penyimpanan data di HP
  static const String _noteKey = 'notes_data';
  static const String _themeKey = 'is_dark_mode';

  // --- LOGIKA MENYIMPAN DATA CATATAN ---
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Ubah List<Note> menjadi List<Map> menggunakan .toJson()
    // 2. Ubah List<Map> menjadi String JSON menggunakan jsonEncode
    final String encodedData = jsonEncode(
      notes.map((note) => note.toJson()).toList()
    );
    
    await prefs.setString(_noteKey, encodedData);
  }

  // --- LOGIKA MENGAMBIL DATA CATATAN ---
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_noteKey);
    
    // Jika data kosong, kembalikan list kosong
    if (notesString == null) return [];
    
    // 1. Decode String JSON menjadi List Dynamic
    final List<dynamic> decodedData = jsonDecode(notesString);

    // 2. Ubah setiap item menjadi Object Note menggunakan .fromJson()
    return decodedData.map((item) => Note.fromJson(item)).toList();
  }
  
  // --- LOGIKA TEMA (Dark/Light Mode) ---
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Default false (Light Mode) jika belum pernah diset
    return prefs.getBool(_themeKey) ?? false;
  }
}