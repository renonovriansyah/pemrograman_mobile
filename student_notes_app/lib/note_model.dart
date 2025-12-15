import 'dart:convert';

class Note {
  String id;
  String title;
  String content;
  DateTime date;
  String category; // Fitur Tugas Pertemuan 8
  bool isPinned;   // Fitur Extra

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    this.isPinned = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
      'isPinned': isPinned,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      isPinned: map['isPinned'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}