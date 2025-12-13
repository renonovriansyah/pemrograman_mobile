import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // --- KEYS & CONTROLLERS (Tetap Sama) ---
  final _identitasKey = GlobalKey<FormState>();
  final _akademikKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tglLahirController = TextEditingController();
  
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  // --- STATE VARIABLES (Tetap Sama) ---
  int _currentStep = 0;
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

  // --- LOGIKA SHARED PREFERENCES (Tetap Sama) ---
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

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _tglLahirController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  // --- UI LOGIC: DATE PICKER (Dipercantik) ---
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
              primary: Color(0xFF4F46E5), // Indigo sesuai tema
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4F46E5),
              ),
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

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Draft?'),
        content: const Text('Data yang tersimpan akan dihapus permanen.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _clearDraft();
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
    _identitasKey.currentState?.reset();
    _akademikKey.currentState?.reset();
    
    _showSnack('Formulir berhasil direset', isError: false);
  }

  // --- LOGIKA STEPPER & SUBMIT (Tetap Sama) ---
  void _handleNextStep() {
    _saveOthers();
    if (_currentStep == 0) {
      if (_identitasKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        _showSnack('Lengkapi data identitas', isError: true);
      }
    } else if (_currentStep == 1) {
      if (_akademikKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        _showSnack('Lengkapi data akademik', isError: true);
      }
    } else {
      _submitForm();
    }
  }

  void _submitForm() async {
    if (!_hobbies.containsValue(true)) {
      _showSnack('Pilih minimal satu hobi!', isError: true);
      return;
    }
    if (!_agreement) {
      setState(() => _showAgreementError = true);
      _showSnack('Setujui syarat & ketentuan.', isError: true);
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
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
          nama: _namaController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          jurusan: _selectedJurusan ?? '-',
          semester: _semester,
          hobi: selectedHobbies,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF0EA5E9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  // --- BUILD UI UTAMA (Updated) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Warna Background Modern
      body: Stack(
        children: [
          // 1. BACKGROUND HEADER (Gradient Curve)
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4F46E5), // Indigo
                  Color(0xFF0EA5E9), // Sky Blue
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 2. HEADER TEXT & RESET BUTTON
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Smart Enroll',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lengkapi data diri Anda',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      // Tombol Reset Transparan
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          tooltip: 'Reset Data',
                          onPressed: _confirmReset,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. FLOATING FORM CARD
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(17),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      child: Theme(
                        // Override tema Stepper agar warnanya sesuai
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(primary: const Color(0xFF4F46E5)),
                        ),
                        child: Stepper(
                          type: StepperType.horizontal,
                          elevation: 0, // Hilangkan shadow bawaan Stepper
                          currentStep: _currentStep,
                          // Custom Icon Control
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                              child: Row(
                                children: [
                                  // Tombol Back (hanya muncul jika bukan step 1)
                                  if (_currentStep > 0 && !_isLoading) ...[
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: details.onStepCancel,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          side: const BorderSide(color: Color(0xFF4F46E5)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                        child: const Text('KEMBALI', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  // Tombol Lanjut / Submit
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _handleNextStep,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        backgroundColor: const Color(0xFF4F46E5),
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shadowColor: const Color(0xFF4F46E5).withAlpha(21),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      child: _isLoading 
                                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(_currentStep == 2 ? 'SUBMIT' : 'LANJUT', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                if (!_isLoading && _currentStep != 2) const Icon(Icons.arrow_forward_rounded, size: 18),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onStepContinue: _handleNextStep,
                          onStepCancel: () {
                            if (_currentStep > 0) setState(() => _currentStep -= 1);
                          },
                          steps: [
                            // --- STEP 1 ---
                            Step(
                              title: const Text('Profil', style: TextStyle(fontSize: 12)),
                              isActive: _currentStep >= 0,
                              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                              content: Form(
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
                            // --- STEP 2 ---
                            Step(
                              title: const Text('Studi', style: TextStyle(fontSize: 12)),
                              isActive: _currentStep >= 1,
                              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                              content: Form(
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
                            // --- STEP 3 ---
                            Step(
                              title: const Text('Minat', style: TextStyle(fontSize: 12)),
                              isActive: _currentStep >= 2,
                              state: StepState.indexed,
                              content: StepMinat(
                                hobbies: _hobbies,
                                agreement: _agreement,
                                showAgreementError: _showAgreementError,
                                onHobiChanged: (key, val) => setState(() => _hobbies[key] = val),
                                onAgreementChanged: (val) => setState(() {
                                  _agreement = val;
                                  if (val) _showAgreementError = false;
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}