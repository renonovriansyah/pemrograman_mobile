import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
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
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentController = TextEditingController(text: widget.existingNote?.content ?? '');
    
    if (widget.existingNote != null) {
      _selectedCategory = widget.existingNote!.category;
      isPinned = widget.existingNote!.isPinned;
    }
  }

  Future<bool> _shouldAllowPop() async {
    final initialTitle = widget.existingNote?.title ?? '';
    final initialContent = widget.existingNote?.content ?? '';
    
    final hasChanges = _titleController.text != initialTitle || 
                       _contentController.text != initialContent;

    if (!hasChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Simpan Perubahan?'),
        content: const Text('Kamu sudah mengetik tapi belum menyimpan. Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Lanjut Mengedit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Buang Perubahan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  void _togglePinState() {
    if (isPinned) {
      setState(() => isPinned = false);
    } else {
      int othersPinnedCount = widget.currentPinnedCount;
      if (widget.existingNote != null && widget.existingNote!.isPinned) {
        othersPinnedCount -= 1;
      }

      if (othersPinnedCount >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Maksimal 3 catatan pinned!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orange[800],
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
    final themeColor = categoryColors[_selectedCategory] ?? Colors.indigo;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false, 
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _shouldAllowPop();
        if (shouldPop) {
          if (context.mounted) {
            Navigator.pop(context); 
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? Colors.white : Colors.black87),
            onPressed: () async {
               final bool shouldPop = await _shouldAllowPop();
               if (shouldPop && context.mounted) {
                 Navigator.pop(context);
               }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, size: 22),
              color: isPinned ? Colors.orange : (isDark ? Colors.grey : Colors.grey[600]),
              onPressed: _togglePinState,
            ),
            
            // --- TOMBOL SIMPAN YANG LEBIH CANTIK ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                label: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                ),
              ),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
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
                      
                      Widget chipWidget = AnimatedContainer(
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
                            if(isSelected) const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                            if(isSelected) const SizedBox(width: 4),
                            Text(cat, style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : color), 
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 12
                            )),
                          ],
                        ),
                      );

                      if (widget.existingNote != null && cat == widget.existingNote!.category) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Hero(
                            tag: 'category_${widget.existingNote!.id}', 
                            child: Material(
                              color: Colors.transparent,
                              child: chipWidget
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: chipWidget,
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
                          style: GoogleFonts.poppins(
                            fontSize: 26, 
                            fontWeight: FontWeight.w700, 
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
                      FadeInLeft(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()), 
                          style: GoogleFonts.poppins(
                            color: Colors.grey[500], 
                            fontWeight: FontWeight.w500, 
                            fontSize: 13
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: TextFormField(
                          controller: _contentController,
                          maxLines: null, 
                          style: GoogleFonts.poppins(
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
      ),
    );
  }
}