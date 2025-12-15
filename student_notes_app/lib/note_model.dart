class Note {
  String id;
  String title;
  String content;
  DateTime date;
  String category;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    this.isPinned = false,
  });

  // --- PEMBARUAN DI SINI ---
  
  // 1. Ubah dari 'fromMap' menjadi 'fromJson'
  // Menerima Map<String, dynamic> agar kompatibel dengan jsonDecode
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      // Gunakan operator ?? false untuk jaga-jaga jika data lama tidak punya field isPinned
      isPinned: json['isPinned'] ?? false, 
    );
  }

  // 2. Ubah dari 'toMap' menjadi 'toJson'
  // Mengembalikan Map<String, dynamic> agar kompatibel dengan jsonEncode
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
      'isPinned': isPinned,
    };
  }
}