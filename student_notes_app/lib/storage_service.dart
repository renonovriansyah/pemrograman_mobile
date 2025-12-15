import 'dart:convert';
import 'package:flutter/foundation.dart'; // 1. Tambahkan ini untuk debugPrint
import 'package:shared_preferences/shared_preferences.dart';
import 'note_model.dart';

class StorageService {
  static const String _noteKey = 'notes_data';
  static const String _themeKey = 'is_dark_mode';

  // --- SIMPAN ---
  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        notes.map((note) => note.toJson()).toList()
      );
      await prefs.setString(_noteKey, encodedData);
    } catch (e) {
      // 2. Gunakan debugPrint agar linter tidak marah
      debugPrint('Error saving notes: $e');
    }
  }

  // --- AMBIL (LOAD) ---
  static Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notesString = prefs.getString(_noteKey);

      if (notesString == null) return [];

      final List<dynamic> decodedData = jsonDecode(notesString);

      return decodedData.map((item) {
        if (item is Map<String, dynamic>) {
          return Note.fromJson(item);
        }
        return null; 
      })
      .whereType<Note>()
      .toList();

    } catch (e) {
      // 2. Gunakan debugPrint di sini juga
      debugPrint('Error loading notes (Resetting data): $e');
      return [];
    }
  }
  
  // --- TEMA ---
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
}