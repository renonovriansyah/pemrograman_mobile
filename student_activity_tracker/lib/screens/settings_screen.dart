import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Akun & Aplikasi',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Konten utama dibagi menjadi dua kolom
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom Kiri (Profil, Preferensi, Integrasi Eksternal)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildProfileSection(context),
                      const SizedBox(height: 20),
                      _buildAppPreferencesSection(),
                      const SizedBox(height: 20),
                      _buildExternalIntegrationSection(),
                      const SizedBox(height: 20),
                      _buildDeleteAccountSection(),
                    ],
                  ),
                ),
                const SizedBox(width: 32),

                // Kolom Kanan (Nama & Aplikasi, Integrasi Khusus)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildTaskSettingsSection(),
                      const SizedBox(height: 20),
                      _buildSpecialIntegrationSection(),
                      const SizedBox(height: 20),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BAGIAN KIRI ---

  Widget _buildProfileSection(BuildContext context) {
    return _buildSettingCard(
      title: 'Profil Maya',
      children: [
        const Text('Profil Maya', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'John Doe',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'john.doe@email.com',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ubah Data'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppPreferencesSection() {
    return _buildSettingCard(
      title: 'Preferensi Aplikasi',
      children: [
        const Text('Ubah Kata Sandi', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Ubah Kata Sandal',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          initialValue: '(GMT +7) Jakarta',
          items: const [
            DropdownMenuItem(value: '(GMT +7) Jakarta', child: Text('(GMT +7) Jakarta')),
          ],
          onChanged: (String? newValue) {},
        ),
      ],
    );
  }

  Widget _buildExternalIntegrationSection() {
    return _buildSettingCard(
      title: 'Integrasi Eksternal',
      children: [
        _buildIntegrationToggle(
          title: 'Mode Gelap',
          subtitle: 'Tema Gelap',
          icon: FontAwesomeIcons.moon,
          color: Colors.black87,
        ),
        _buildIntegrationToggle(
          title: 'Zona Warna',
          subtitle: 'Pilih Zona Warna',
          icon: FontAwesomeIcons.palette,
          color: Colors.purple,
        ),
        // Placeholder untuk pilihan warna
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildColorCircle(Colors.blue),
            _buildColorCircle(Colors.yellow),
            _buildColorCircle(Colors.orange),
            _buildColorCircle(Colors.purple),
            _buildColorCircle(Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildDeleteAccountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
        child: const Text('Hapus Akun', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- WIDGET BAGIAN KANAN ---

  Widget _buildTaskSettingsSection() {
    return _buildSettingCard(
      title: 'Nama Modul & Aplikasi',
      children: [
        _buildAppToggle(
          title: 'Nama Riil Proyek',
          subtitle: 'Modul Riil',
          icon: FontAwesomeIcons.lightbulb,
        ),
        _buildAppToggle(
          title: 'Mulai Timer',
          subtitle: 'Timer Waktu',
          icon: FontAwesomeIcons.clock,
        ),
        const Divider(),
        _buildAppToggle(
          title: 'Email',
          subtitle: 'Notifikasi Email',
          icon: FontAwesomeIcons.envelope,
          initialValue: true,
        ),
        _buildAppToggle(
          title: 'Baca Buku 30 Menit',
          subtitle: 'Target Kebiasaan',
          icon: FontAwesomeIcons.book,
          initialValue: true,
        ),
      ],
    );
  }

  Widget _buildSpecialIntegrationSection() {
    return _buildSettingCard(
      title: 'Integrasi Eksternal',
      children: [
        _buildIntegrationToggle(
          title: 'Oothendár',
          subtitle: 'Integrasi Kalender',
          icon: FontAwesomeIcons.calendar,
          color: Colors.blue,
          initialValue: true,
        ),
        _buildIntegrationToggle(
          title: 'Notion',
          subtitle: 'Integrasi Catatan',
          icon: FontAwesomeIcons.n,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {},
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


  // --- WIDGET PEMBANTU ---

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

  Widget _buildIntegrationToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool initialValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Switch(
            value: initialValue,
            onChanged: (bool value) {},
            activeThumbColor: Colors.teal,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    bool initialValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                FaIcon(icon, size: 20, color: Colors.teal),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: initialValue,
            onChanged: (bool value) {},
            activeThumbColor: Colors.teal,
          ),
        ],
      ),
    );
  }
  
  Widget _buildColorCircle(Color color) {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(top: 10, right: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 2),
      ),
    );
  }
}