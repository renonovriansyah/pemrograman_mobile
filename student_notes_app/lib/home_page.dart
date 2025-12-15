import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'note_model.dart';
import 'note_form_page.dart';
import 'storage_service.dart';

// Definisi Warna Kategori
final Map<String, Color> categoryColors = {
  'Kuliah': const Color(0xFF4F46E5),    // Indigo
  'Organisasi': const Color(0xFFEA580C), // Orange
  'Pribadi': const Color(0xFF059669),    // Emerald
  'Lainnya': const Color(0xFFDB2777),    // Pink
};

class HomePage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HomePage({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Kuliah', 'Organisasi', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final list = await StorageService.loadNotes();
    setState(() {
      _notes = list;
      _filterNotes();
    });
  }

  void _filterNotes() {
    setState(() {
      _filteredNotes = _notes.where((note) {
        final matchCategory = _selectedCategory == 'Semua' || note.category == _selectedCategory;
        final matchSearch = note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            note.content.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchCategory && matchSearch;
      }).toList();
      _filteredNotes.sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.date.compareTo(a.date);
      });
    });
  }
  
  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((n) => n.id == id);
      StorageService.saveNotes(_notes);
      _filterNotes();
    });
  }
  
  void _togglePin(String id) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        // Cek Limit Pin: Maksimal 3
        if (!_notes[index].isPinned) {
          final pinnedCount = _notes.where((n) => n.isPinned).length;
          if (pinnedCount >= 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Maksimal hanya 3 catatan yang dapat disematkan!', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red[400],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
            return;
          }
        }
        
        _notes[index].isPinned = !_notes[index].isPinned;
        StorageService.saveNotes(_notes);
        _filterNotes();
      }
    });
  }

  Future<void> _navigateToForm({Note? note}) async {
    // Hitung jumlah pin untuk dikirim ke form (validasi di sana)
    final pinnedCount = _notes.where((n) => n.isPinned).length;

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            NoteFormPage(existingNote: note, currentPinnedCount: pinnedCount),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutQuart;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        int index = _notes.indexWhere((n) => n.id == result.id);
        if (index != -1) {
          _notes[index] = result;
        } else {
          _notes.add(result);
        }
        StorageService.saveNotes(_notes);
        _filterNotes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgHeaderColor = widget.isDarkMode ? const Color(0xFF2C2C3E) : Colors.white;
    final txtColor = widget.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. CUSTOM HEADER
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bgHeaderColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            child: Text('Halo, Reno 👋', 
                              style: TextStyle(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 4),
                          FadeInDown(
                            delay: const Duration(milliseconds: 200),
                            child: Text('Catatan Kamu', 
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: txtColor)),
                          ),
                        ],
                      ),
                      FadeInRight(
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(widget.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round),
                            color: widget.isDarkMode ? Colors.orange : Colors.indigo,
                            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode ? Colors.grey[800] : const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        onChanged: (val) {
                           _searchQuery = val;
                           _filterNotes();
                        },
                        style: TextStyle(color: txtColor),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search_rounded, color: Colors.grey[400]),
                          hintText: 'Cari ide menarik...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. CATEGORY PILLS (Horizontal Scroll)
            const SizedBox(height: 16),
            FadeInRight(
              delay: const Duration(milliseconds: 400),
              child: SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    
                    final activeColor = cat == 'Semua' 
                        ? const Color.fromARGB(255, 227, 234, 90) // Kuning
                        : (categoryColors[cat] ?? const Color(0xFF6C63FF));
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                          _filterNotes();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? activeColor 
                            : (widget.isDarkMode ? Colors.grey[800] : Colors.white),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: isSelected 
                            ? [BoxShadow(color: activeColor.withAlpha(80), blurRadius: 10, offset: const Offset(0, 4))] 
                            : [],
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected 
                                ? Colors.white 
                                : Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 3. LIST CATATAN
            Expanded(
              child: _filteredNotes.isEmpty
                  ? Center(
                      child: ZoomIn(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn-icons-png.flaticon.com/512/7486/7486744.png', 
                              height: 150,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.edit_note, size: 80, color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            Text('Belum ada catatan di sini', style: TextStyle(color: Colors.grey[400])),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = _filteredNotes[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 100),
                          child: _buildColorfulCard(note),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: const Duration(milliseconds: 800),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF6C63FF), // Sesuaikan dengan warna tema
          onPressed: () => _navigateToForm(),
          label: const Text('Buat Catatan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildColorfulCard(Note note) {
    final color = categoryColors[note.category] ?? Colors.grey;
    final isDark = widget.isDarkMode;

    return BouncingButton(
      onPressed: () => _navigateToForm(note: note),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C3E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.transparent : Colors.grey.withAlpha(20),
            width: 1
          ),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0, top: 0, bottom: 0,
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          note.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10, 
                            fontWeight: FontWeight.w800, 
                            color: color,
                            letterSpacing: 1
                          ),
                        ),
                      ),
                      if (note.isPinned)
                        Pulse(
                          infinite: true,
                          child: Icon(Icons.push_pin, color: Colors.orange[400], size: 18),
                        )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF2D3142),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.5
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('d MMM y').format(note.date),
                            style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _deleteNote(note.id),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(20),
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
             Positioned(
               right: 0, top: 0,
               child: IconButton(
                 icon: const Icon(Icons.more_horiz, color: Colors.transparent),
                 onPressed: () => _togglePin(note.id),
               ),
             )
          ],
        ),
      ),
    );
  }
}

class BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scale;
  const BouncingButton({super.key, required this.child, required this.onPressed, this.scale = 0.95});
  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}
class _BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 1.0);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(_controller);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) { _controller.reverse(); widget.onPressed(); },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}