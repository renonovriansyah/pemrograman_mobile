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
  // --- KUNCI VALIDASI TERPISAH (Agar validasi per step) ---
  final _identitasKey = GlobalKey<FormState>(); // Key untuk Step 1
  final _akademikKey = GlobalKey<FormState>();  // Key untuk Step 2
  // Step 3 tidak butuh FormKey karena validasinya manual (Checkbox/Switch)

  // Controllers
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tglLahirController = TextEditingController();
  
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  // State
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

    // Auto-Save listeners
    _namaController.addListener(() => _saveToPrefs('nama', _namaController.text));
    _emailController.addListener(() => _saveToPrefs('email', _emailController.text));
    _phoneController.addListener(() => _saveToPrefs('phone', _phoneController.text));
  }

  // --- SHARED PREFERENCES ---
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
              primary: Color(0xFF6200EA), 
              onPrimary: Colors.white, 
              onSurface: Color(0xFF2D2D2D),
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
        content: const Text('Data yang tersimpan di memori akan dihapus permanen.'),
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
    // Reset kedua key form
    _identitasKey.currentState?.reset();
    _akademikKey.currentState?.reset();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulir berhasil direset')),
    );
  }

  // --- LOGIKA "LANJUT" DENGAN VALIDASI ---
  void _handleNextStep() {
    _saveOthers(); // Auto-save draft

    if (_currentStep == 0) {
      // --- VALIDASI STEP 1 (IDENTITAS) ---
      if (_identitasKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        _showSnack('Mohon lengkapi data identitas dengan benar', isError: true);
      }
    } else if (_currentStep == 1) {
      // --- VALIDASI STEP 2 (AKADEMIK) ---
      if (_akademikKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        _showSnack('Mohon lengkapi data akademik', isError: true);
      }
    } else {
      // --- SUBMIT FINAL (STEP 3) ---
      _submitForm();
    }
  }

  void _submitForm() async {
    // Validasi Manual Step 3
    if (!_hobbies.containsValue(true)) {
      _showSnack('Pilih minimal satu hobi!', isError: true);
      return;
    }
    if (!_agreement) {
      setState(() => _showAgreementError = true);
      _showSnack('Anda harus menyetujui syarat & ketentuan.', isError: true);
      return;
    }

    // Jika sampai sini, berarti Step 3 valid.
    // (Step 1 & 2 sudah divalidasi saat tombol "Lanjut")
    
    debugPrint("Semua Validasi Sukses, Mulai Loading...");
    
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
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6200EA),
              Color(0xFF9900FF),
              Color(0xFF00BFA5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Smart Enroll',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white),
                      tooltip: 'Reset Draft',
                      onPressed: _confirmReset,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    // CATATAN: Form Luar dihapus, diganti Form per Step
                    child: Stepper(
                      type: StepperType.horizontal,
                      elevation: 0,
                      currentStep: _currentStep,
                      connectorColor: WidgetStateProperty.resolveWith((states) {
                        return states.contains(WidgetState.selected) ? const Color(0xFF6200EA) : Colors.grey.shade300;
                      }),
                      controlsBuilder: (context, details) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  // Panggil fungsi _handleNextStep saat tombol ditekan
                                  onPressed: _isLoading ? null : _handleNextStep,
                                  child: _isLoading 
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                                      : Text(_currentStep == 2 ? 'SUBMIT' : 'LANJUT'),
                                ),
                              ),
                              if (_currentStep > 0 && !_isLoading) ...[
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('KEMBALI'),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                      onStepContinue: _handleNextStep,
                      onStepCancel: () {
                        if (_currentStep > 0) setState(() => _currentStep -= 1);
                      },
                      steps: [
                        // --- STEP 1: Form Identitas ---
                        Step(
                          title: const Text('Profil'),
                          isActive: _currentStep >= 0,
                          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                          content: Form( // Bungkus dengan Form khusus Step 1
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
                        // --- STEP 2: Form Akademik ---
                        Step(
                          title: const Text('Studi'),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                          content: Form( // Bungkus dengan Form khusus Step 2
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
                        // --- STEP 3: Minat (Tanpa Form Key, Manual) ---
                        Step(
                          title: const Text('Minat'),
                          isActive: _currentStep >= 2,
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
            ],
          ),
        ),
      ),
    );
  }
}