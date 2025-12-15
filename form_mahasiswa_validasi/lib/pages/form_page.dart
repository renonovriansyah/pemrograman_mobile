import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/step_identitas.dart';
import '../widgets/step_akademik.dart';
import '../widgets/step_minat.dart';
import 'result_page.dart';

class FormMahasiswaValidasiPage extends StatefulWidget {
  const FormMahasiswaValidasiPage({super.key});

  @override
  State<FormMahasiswaValidasiPage> createState() => _FormMahasiswaValidasiPageState();
}

class _FormMahasiswaValidasiPageState extends State<FormMahasiswaValidasiPage> {
  // --- KEYS & CONTROLLERS ---
  final _identitasKey = GlobalKey<FormState>();
  final _akademikKey = GlobalKey<FormState>();
  
  // Page Controller untuk Transisi Slide
  final PageController _pageController = PageController();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tglLahirController = TextEditingController();
  
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  // --- STATE VARIABLES ---
  int _currentStep = 0; // 0, 1, 2
  final int _totalSteps = 3;
  
  String? _selectedJurusan;
  double _semester = 1.0;
  bool _agreement = false;
  bool _showAgreementError = false;
  bool _isLoading = false;

  final Map<String, bool> _initialHobbies = {
    'Coding': false, 'Desain UI/UX': false, 'Gaming': false, 'Musik': false,
  };
  late Map<String, bool> _hobbies;
  final List<String> _jurusanList = [
    'Teknik Informatika', 'Sistem Informasi', 'Manajemen Informatika', 'Teknik Komputer',
  ];

  @override
  void initState() {
    super.initState();
    _hobbies = Map.from(_initialHobbies);
    _loadDraft();
    
    // Listeners
    _namaController.addListener(() => _saveToPrefs('nama', _namaController.text));
    _emailController.addListener(() => _saveToPrefs('email', _emailController.text));
    _phoneController.addListener(() => _saveToPrefs('phone', _phoneController.text));
  }

  // --- LOGIKA SHARED PREFS ---
  Future<void> _saveToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _saveOthers() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedJurusan != null) await prefs.setString('jurusan', _selectedJurusan!);
    await prefs.setDouble('semester', _semester);
    await prefs.setString('tgl_lahir', _tglLahirController.text);
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaController.text = prefs.getString('nama') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _tglLahirController.text = prefs.getString('tgl_lahir') ?? '';
      _selectedJurusan = prefs.getString('jurusan');
      _semester = prefs.getDouble('semester') ?? 1.0;
    });
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- LOGIKA RESET & DATE PICKER ---
  void _confirmReset() {
    showDialog(
      context: context,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          title: Text('Hapus Draft?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('Data yang tersimpan akan dihapus permanen.', style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey))
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetForm();
              },
              child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    _clearDraft(); // Menggunakan fungsi _clearDraft agar tidak error "unused element"
    _namaController.clear();
    _emailController.clear();
    _phoneController.clear();
    _tglLahirController.clear();
    
    setState(() {
      _currentStep = 0;
      _semester = 1.0;
      _selectedJurusan = null;
      _agreement = false;
      _showAgreementError = false;
      _hobbies = Map.from(_initialHobbies);
    });
    
    // Reset form state key
    _identitasKey.currentState?.reset();
    _akademikKey.currentState?.reset();
    
    // Reset halaman ke awal
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }

    _showSnack('Formulir berhasil direset', isError: false);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1), // Indigo
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF6366F1)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = DateFormat('dd MMMM yyyy', 'id_ID').format(picked);
      });
      _saveToPrefs('tgl_lahir', _tglLahirController.text);
    }
  }

  // --- NAVIGATION LOGIC ---
  void _nextPage() {
    _saveOthers();
    bool isValid = false;

    if (_currentStep == 0) {
      if (_identitasKey.currentState!.validate()) {
        isValid = true;
      } else {
        _showSnack('Mohon lengkapi data identitas', isError: true);
      }
    } else if (_currentStep == 1) {
      if (_akademikKey.currentState!.validate()) {
        isValid = true;
      } else {
        _showSnack('Mohon lengkapi data akademik', isError: true);
      }
    } else {
       return; 
    }

    if (isValid) {
      setState(() => _currentStep += 1);
      _pageController.animateToPage(
        _currentStep, 
        duration: const Duration(milliseconds: 600), 
        curve: Curves.easeOutQuart
      );
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
      _pageController.animateToPage(
        _currentStep, 
        duration: const Duration(milliseconds: 600), 
        curve: Curves.easeOutQuart
      );
    }
  }

  void _submitForm() async {
    if (!_hobbies.containsValue(true)) {
      _showSnack('Pilih minimal satu hobi!', isError: true);
      return;
    }
    if (!_agreement) {
      setState(() => _showAgreementError = true);
      _showSnack('Wajib menyetujui syarat & ketentuan.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    List<String> selectedHobbies = _hobbies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => ResultPage(
          nama: _namaController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          jurusan: _selectedJurusan ?? '-',
          semester: _semester,
          hobi: selectedHobbies,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack)
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- BUILD UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate 100
      body: Stack(
        children: [
          // --- 1. DECORATIVE BACKGROUND (Fixed blurRadius) ---
          Positioned(
            top: -100,
            right: -100,
            child: FadeInDown(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withValues(alpha: 0.2), // Fix: use withValues(alpha)
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                      blurRadius: 80, // Fix: blurRadius moved to BoxShadow
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
           Positioned(
            top: 100,
            left: -50,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.2), // Fix: use withValues(alpha)
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                      blurRadius: 60, // Fix: blurRadius moved to BoxShadow
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // --- 2. CUSTOM HEADER & PROGRESS ---
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registrasi',
                              style: GoogleFonts.poppins(
                                fontSize: 28, 
                                fontWeight: FontWeight.w800, 
                                color: const Color(0xFF1E293B),
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Langkah ${_currentStep + 1} dari $_totalSteps',
                              style: GoogleFonts.poppins(
                                fontSize: 14, 
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        // Reset Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          ),
                          child: IconButton(
                            onPressed: _confirmReset,
                            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B)),
                            tooltip: 'Reset Form',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // Animated Progress Bar Line
                FadeIn(
                  delay: const Duration(milliseconds: 300),
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                              width: constraints.maxWidth * ((_currentStep + 1) / _totalSteps),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF0EA5E9)]),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withValues(alpha: 0.4), // Fix: withValues(alpha)
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- 3. PAGE VIEW CONTENT (SLIDING) ---
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildCard(
                        child: Form(
                          key: _identitasKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: StepIdentitas(
                            namaController: _namaController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            tglLahirController: _tglLahirController,
                            emailFocusNode: _emailFocusNode,
                            phoneFocusNode: _phoneFocusNode,
                            onTapTglLahir: () => _selectDate(context),
                          ),
                        ),
                      ),
                      _buildCard(
                        child: Form(
                          key: _akademikKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: StepAkademik(
                            selectedJurusan: _selectedJurusan,
                            jurusanList: _jurusanList,
                            semester: _semester,
                            onJurusanChanged: (val) {
                              setState(() => _selectedJurusan = val);
                              _saveOthers();
                            },
                            onSemesterChanged: (val) {
                              setState(() => _semester = val);
                              _saveOthers();
                            },
                          ),
                        ),
                      ),
                      _buildCard(
                        child: StepMinat(
                          hobbies: _hobbies,
                          agreement: _agreement,
                          showAgreementError: _showAgreementError,
                          onHobiChanged: (key, val) => setState(() => _hobbies[key] = val),
                          onAgreementChanged: (val) => setState(() {
                            _agreement = val;
                            if (val) {
                              _showAgreementError = false;
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 4. NAVIGATION BUTTONS ---
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Back Button
                      if (_currentStep > 0)
                        Expanded(
                          flex: 1,
                          child: FadeInUp(
                            duration: const Duration(milliseconds: 500),
                            child: _AnimatedHoverButton(
                              text: 'Kembali',
                              isPrimary: false,
                              onTap: _isLoading ? null : _prevPage,
                            ),
                          ),
                        ),
                      
                      if (_currentStep > 0) const SizedBox(width: 16),
                      
                      // Next/Submit Button
                      Expanded(
                        flex: 2,
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 100),
                          child: _AnimatedHoverButton(
                            text: _currentStep == 2 ? 'Kirim Data' : 'Lanjut',
                            isPrimary: true,
                            isLoading: _isLoading,
                            onTap: _isLoading ? null : (_currentStep == 2 ? _submitForm : _nextPage),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Wrapper untuk Kartu Putih
  Widget _buildCard({required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF64748B).withValues(alpha: 0.08), // Fix: withValues(alpha)
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// --- CUSTOM WIDGET: ANIMATED HOVER BUTTON ---
class _AnimatedHoverButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback? onTap;
  final bool isLoading;

  const _AnimatedHoverButton({
    required this.text,
    required this.isPrimary,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<_AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<_AnimatedHoverButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56,
            decoration: BoxDecoration(
              color: widget.isPrimary 
                  ? (_isHovered ? const Color(0xFF4F46E5) : const Color(0xFF6366F1))
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: widget.isPrimary ? null : Border.all(color: Colors.grey[300]!, width: 2),
              boxShadow: widget.isPrimary && _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.5), // Fix: withValues(alpha)
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Text(
                      widget.text,
                      style: GoogleFonts.poppins(
                        color: widget.isPrimary ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}