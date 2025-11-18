// lib/screens/settings_screen.dart (Final dengan Firebase Profile)
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Wajib
import 'package:shared_preferences/shared_preferences.dart'; // Tetap untuk settings lokal

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Hanya simpan state untuk switch yang tidak terkait profil
  bool _isDarkMode = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Untuk validasi form

  @override
  void initState() {
    super.initState();
    _loadLocalSettings();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // --- LOCAL SETTINGS LOGIC (DarkMode) ---
  void _loadLocalSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // --- SIMPAN PROFIL KE FIRESTORE ---
  void _saveProfile(UserProvider userProvider) async {
    if (_formKey.currentState!.validate()) {
      await userProvider.updateProfile(_nameController.text, _emailController.text);
      
      // Safety check for async gap
      if (!mounted) return; 

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan di Firestore!')),
      );
    }
  }

  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    // Ambil profile dari provider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final profile = userProvider.profile;

        // Sinkronkan text controller dengan data Firestore saat pertama dimuat
        if (profile != null && _nameController.text.isEmpty && _emailController.text.isEmpty) {
             _nameController.text = profile.name;
             _emailController.text = profile.email;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profil & Pengaturan Aplikasi',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  
                  // Layout 2 Kolom Sederhana
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kolom Kiri: Profil
                      Expanded(
                        flex: 1,
                        child: _buildProfileSection(userProvider),
                      ),
                      const SizedBox(width: 32),
                      // Kolom Kanan: Toggles & Aksi
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildAppPreferencesSection(),
                            const SizedBox(height: 20),
                            _buildSaveButton(userProvider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET BAGIAN KIRI: PROFIL FIRESTORE ---

  Widget _buildProfileSection(UserProvider userProvider) {
    final profile = userProvider.profile;
    
    return _buildSettingCard(
      title: 'Profil Pengguna',
      children: [
        if (profile == null) 
          const Center(child: CircularProgressIndicator())
        else ...[
          const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi.' : null,
          ),
          const SizedBox(height: 16),
          const Text('Alamat Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            validator: (value) => value == null || !value.contains('@') ? 'Masukkan email yang valid.' : null,
          ),
        ]
      ],
    );
  }
  
  // --- WIDGET BAGIAN KANAN: PREFERENSI & TOGGLES ---

  Widget _buildAppPreferencesSection() {
    return _buildSettingCard(
      title: 'Pengaturan Dasar',
      children: [
        _buildAppToggle(
          title: 'Mode Gelap',
          subtitle: 'Ubah tema aplikasi',
          icon: FontAwesomeIcons.moon,
          color: Colors.black,
          initialValue: _isDarkMode,
          onChanged: (value) {
            setState(() { _isDarkMode = value; });
            _saveSetting('isDarkMode', value);
          },
        ),
        const Divider(),
        _buildAppToggle(
          title: 'Notifikasi Email',
          subtitle: 'Kirim pengingat harian dan laporan',
          icon: FontAwesomeIcons.envelope,
          color: Colors.redAccent,
          initialValue: true, // Statis, bisa disambungkan ke Provider jika ada
          onChanged: (v) {},
        ),
        _buildAppToggle(
          title: 'Integrasi Kalender',
          subtitle: 'Sinkronisasi dengan Oothendár',
          icon: FontAwesomeIcons.calendar,
          color: Colors.blue,
          initialValue: true, 
          onChanged: (v) {},
        ),
      ],
    );
  }

  Widget _buildSaveButton(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => _saveProfile(userProvider), // Panggil fungsi simpan
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }


  // --- WIDGET PEMBANTU (Helper Widgets) ---

  Widget _buildSettingCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildAppToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool initialValue,
    required ValueChanged<bool> onChanged,
  }) {
    // Menggunakan SwitchListTile untuk UX yang lebih baik
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      value: initialValue,
      onChanged: onChanged,
      secondary: FaIcon(icon, size: 20, color: color),
      activeThumbColor: Colors.teal,
      contentPadding: EdgeInsets.zero,
    );
  }
}