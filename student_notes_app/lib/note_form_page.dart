import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'note_model.dart';
import 'home_page.dart'; 

class NoteFormPage extends StatefulWidget {
  final Note? existingNote;
  final int currentPinnedCount; // [MODIFIKASI 1: Tambah parameter ini]

  // Update Constructor
  const NoteFormPage({
    super.key, 
    this.existingNote, 
    required this.currentPinnedCount // Wajib diisi
  });

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _selectedCategory = 'Kuliah';
  bool isPinned = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    if (widget.existingNote != null) {
      _selectedCategory = widget.existingNote!.category;
      isPinned = widget.existingNote!.isPinned;
    }
  }

  // [MODIFIKASI 2: Logic validasi pin limit]
  void _togglePinState() {
    if (isPinned) {
      // Kalau sudah dipin, mau un-pin -> BOLEH
      setState(() => isPinned = false);
    } else {
      // Kalau belum dipin, mau nge-pin -> CEK LIMIT
      
      // Hitung jumlah pin orang lain (exclude diri sendiri jika sedang edit)
      int othersPinnedCount = widget.currentPinnedCount;
      if (widget.existingNote != null && widget.existingNote!.isPinned) {
        othersPinnedCount -= 1;
      }

      if (othersPinnedCount >= 3) {
        // Tampilkan warning
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Maksimal 3 catatan pinned!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red[400],
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Boleh pin
        setState(() => isPinned = true);
      }
    }
  }

  // ... (dispose dan _saveNote TETAP SAMA seperti sebelumnya)
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;
    final String id = widget.existingNote?.id ?? const Uuid().v4(); 
    final note = Note(
      id: id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: DateTime.now(),
      category: _selectedCategory,
      isPinned: isPinned,
    );
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = categoryColors[_selectedCategory] ?? Colors.black;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // [MODIFIKASI 3: Panggil _togglePinState di onPressed]
          IconButton(
            icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            color: isPinned ? Colors.orange : null,
            onPressed: _togglePinState, // Panggil fungsi validasi tadi
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.check_circle, size: 30),
              color: themeColor, 
            ),
          )
        ],
      ),
      // ... (Body TETAP SAMA seperti sebelumnya)
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            FadeInDown(
              child: SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: categoryColors.keys.map((cat) {
                     final isSelected = _selectedCategory == cat;
                     final color = categoryColors[cat]!;
                     return GestureDetector(
                       onTap: () => setState(() => _selectedCategory = cat),
                       child: AnimatedContainer(
                         duration: const Duration(milliseconds: 200),
                         margin: const EdgeInsets.only(right: 12),
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         decoration: BoxDecoration(
                           color: isSelected ? color : color.withAlpha(30),
                           borderRadius: BorderRadius.circular(20),
                           border: Border.all(color: isSelected ? Colors.transparent : color, width: 1.5)
                         ),
                         child: Row(
                           children: [
                             if(isSelected) const Icon(Icons.check, size: 14, color: Colors.white),
                             if(isSelected) const SizedBox(width: 4),
                             Text(cat, style: TextStyle(
                               color: isSelected ? Colors.white : color, 
                               fontWeight: FontWeight.bold,
                               fontSize: 12
                             )),
                           ],
                         ),
                       ),
                     );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      child: TextFormField(
                        controller: _titleController,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                        decoration: const InputDecoration(
                          hintText: 'Judul...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Judul wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: TextFormField(
                        controller: _contentController,
                        maxLines: null,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                        decoration: const InputDecoration(
                          hintText: 'Tulis ceritamu di sini...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Isi tidak boleh kosong' : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}