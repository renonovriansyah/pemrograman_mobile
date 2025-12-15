import 'dart:convert'; // [FIX 1: Tambahkan ini agar 'json' dikenali]
import 'package:shared_preferences/shared_preferences.dart';
import 'note_model.dart';

class StorageService {
  static const String _noteKey = 'notes_data';
  static const String _themeKey = 'is_dark_mode';

  // Simpan List Notes
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    // [FIX 2: Panggil 'NoteListExtension.encode' bukan 'Note.encode']
    final String encodedData = NoteListExtension.encode(notes); 
    await prefs.setString(_noteKey, encodedData);
  }

  // Load List Notes
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_noteKey);
    if (notesString == null) return [];
    
    // Panggil decode dari extension
    return NoteListExtension.decode(notesString);
  }
  
  // Save & Load Theme
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
}

// Extension untuk encode List<Note>
extension NoteListExtension on Note {
  static String encode(List<Note> notes) => 
    json.encode(notes.map<Map<String, dynamic>>((note) => note.toMap()).toList());
    
  static List<Note> decode(String notes) =>
    (json.decode(notes) as List<dynamic>)
      .map<Note>((item) => Note.fromMap(item))
      .toList();
}