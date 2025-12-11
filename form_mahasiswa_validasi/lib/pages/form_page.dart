import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  
  // Controller
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  // State
  int _currentStep = 0;
  String? _selectedJurusan;
  double _semester = 1.0;
  bool _agreement = false;
  bool _showAgreementError = false;

  // Data Default Hobi (Reset akan mengembalikan ke sini)
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
    _hobbies = Map.from(_initialHobbies); // Copy data awal
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  // --- FITUR RESET FORM ---
  void _resetForm() {
    _namaController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() {
      _currentStep = 0;
      _semester = 1.0;
      _selectedJurusan = null;
      _agreement = false;
      _showAgreementError = false;
      _hobbies = Map.from(_initialHobbies); // Reset checkbox
    });
    // Hapus pesan error visual
    _formKey.currentState?.reset(); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulir berhasil direset')),
    );
  }

  void _submitForm() {
    if (!_hobbies.containsValue(true)) {
      _showSnack('Pilih minimal satu hobi!', isError: true);
      return;
    }
    if (!_agreement) {
      setState(() => _showAgreementError = true);
      _showSnack('Anda harus menyetujui syarat & ketentuan.', isError: true);
      return;
    }

    if (_formKey.currentState!.validate()) {
      List<String> selectedHobbies = _hobbies.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // --- NAVIGASI DENGAN ANIMASI CUSTOM ---
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
            nama: _namaController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            jurusan: _selectedJurusan ?? '-',
            semester: _semester,
            hobi: selectedHobbies,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Efek Slide dari bawah + Fade
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Enroll'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol Reset
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Form',
            onPressed: _resetForm,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Hero Icon (Ini yang akan terbang ke halaman sebelah)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Hero(
              tag: 'profile-icon',
              child: Icon(Icons.account_circle, size: 80, color: Colors.indigo),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Stepper(
                type: StepperType.horizontal, // Ubah ke Horizontal biar lebih clean
                elevation: 0,
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep += 1);
                  } else {
                    _submitForm();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep -= 1);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            child: Text(
                              _currentStep == 2 ? 'SUBMIT DATA' : 'LANJUT',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('KEMBALI', style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('Data'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                    content: StepIdentitas(
                      namaController: _namaController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      emailFocusNode: _emailFocusNode,
                      phoneFocusNode: _phoneFocusNode,
                    ),
                  ),
                  Step(
                    title: const Text('Akademik'),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                    content: StepAkademik(
                      selectedJurusan: _selectedJurusan,
                      jurusanList: _jurusanList,
                      semester: _semester,
                      onJurusanChanged: (val) => setState(() => _selectedJurusan = val),
                      onSemesterChanged: (val) => setState(() => _semester = val),
                    ),
                  ),
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
        ],
      ),
    );
  }
}