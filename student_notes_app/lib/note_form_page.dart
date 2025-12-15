import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart'; // Jangan lupa import ini
import 'note_model.dart';
import 'home_page.dart'; 

class NoteFormPage extends StatefulWidget {
  final Note? existingNote;
  final int currentPinnedCount;

  const NoteFormPage({
    super.key, 
    this.existingNote, 
    required this.currentPinnedCount
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
    // Isi data jika mode edit
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    
    if (widget.existingNote != null) {
      _selectedCategory = widget.existingNote!.category;
      isPinned = widget.existingNote!.isPinned;
    }
  }

  void _togglePinState() {
    if (isPinned) {
      setState(() => isPinned = false);
    } else {
      // Cek Limit Pin
      int othersPinnedCount = widget.currentPinnedCount;
      // Jika sedang edit nota yang SUDAH dipin, kurangi hitungan agar tidak double count
      if (widget.existingNote != null && widget.existingNote!.isPinned) {
        othersPinnedCount -= 1;
      }

      if (othersPinnedCount >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Maksimal 3 catatan pinned!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => isPinned = true);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;
    
    // Jika ID null (baru), buat ID baru. Jika ada (edit), pakai ID lama.
    final String id = widget.existingNote?.id ?? const Uuid().v4(); 
    
    final note = Note(
      id: id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: DateTime.now(), // Update tanggal ke waktu edit terakhir
      category: _selectedCategory,
      isPinned: isPinned,
    );
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    // Ambil warna kategori dari home_page.dart
    final themeColor = categoryColors[_selectedCategory] ?? Colors.indigo;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background mengikuti Theme global agar transisi halus
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Tombol Pin
          IconButton(
            icon: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            color: isPinned ? Colors.orange : (isDark ? Colors.grey : Colors.grey[600]),
            onPressed: _togglePinState,
          ),
          // Tombol Simpan
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // 1. KATEGORI PILIHAN
            FadeInDown(
              duration: const Duration(milliseconds: 400),
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
                            color: isSelected ? color : (isDark ? Colors.white.withAlpha(25) : color.withAlpha(24)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? Colors.transparent : (isDark ? Colors.transparent : color), 
                              width: 1
                            )
                          ),
                          child: Row(
                            children: [
                              if(isSelected) const Icon(Icons.check, size: 14, color: Colors.white),
                              if(isSelected) const SizedBox(width: 4),
                              Text(cat, style: GoogleFonts.poppins( // Pakai Google Fonts
                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : color), 
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
                    
                    // 2. INPUT JUDUL (BOLD & POPPINS)
                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      child: TextFormField(
                        controller: _titleController,
                        style: GoogleFonts.poppins( // Pakai Font Poppins
                          fontSize: 26, 
                          fontWeight: FontWeight.w700, // Bold tebal
                          color: isDark ? Colors.white : const Color(0xFF2D3142),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Judul...',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400], 
                            fontSize: 26, 
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        validator: (v) => v!.trim().isEmpty ? 'Judul wajib diisi' : null,
                      ),
                    ),
                    
                    // TANGGAL HARI INI
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()), // Format Indo
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500], 
                          fontWeight: FontWeight.w500, 
                          fontSize: 13
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 3. INPUT KONTEN
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: TextFormField(
                        controller: _contentController,
                        maxLines: null, // Unlimited lines
                        style: GoogleFonts.poppins( // Pakai Font Poppins
                          fontSize: 16, 
                          height: 1.6,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tulis ceritamu di sini...',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
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