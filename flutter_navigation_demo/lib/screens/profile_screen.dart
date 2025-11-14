import 'package:flutter/material.dart';

// Definisi data yang bisa diedit
class UserProfileData {
  String npm = '701230016';
  String email = 'reno@uinjambi.ac.id';
  String phone = '0822-8966-9969';
  String dosenWali = 'Efitra, M.Kom';
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileData _userData = UserProfileData();
  bool _isEditing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --- WIDGET HELPER UMUM ---
  Widget buildProfileTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade800),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      trailing: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  Widget _buildEditableField(String label, IconData icon, String initialValue, void Function(String?)? onSaved) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade800),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      trailing: SizedBox(
        width: 150,
        child: TextFormField(
          initialValue: initialValue,
          textAlign: TextAlign.end,
          readOnly: !_isEditing, // HANYA BISA DIEDIT JIKA isEditing = true
          onSaved: onSaved,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            border: _isEditing ? const UnderlineInputBorder() : InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      if (_isEditing) {
        // Jika sudah selesai edit, simpan data
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
        }
      }
      _isEditing = !_isEditing;
    });
  }
  
  // --- WIDGET HEADER PROFIL BARU ---
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF001F3F), 
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo.png', height: 40, width: 40),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UNIVERSITAS', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('BHINNEKA TUNGGAL IKA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white38, height: 30),

          // Foto Profil
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profil.jpg'), 
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
          
          // Nama dan Jurusan
          const Text(
            'M. Reno Novriansyah (Mahasiswa Aktif)',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Sistem Informasi - Angkatan 2023',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // --- WIDGET FOOTER/DRAWER HELPERS (Disalin dari navigation_menu_screen.dart) ---
  Widget _buildContactRow(IconData icon, String text) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Icon(icon, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13))),
              ],
          ),
      );
  }

  Widget _buildSocialMediaRow() {
      return Row(
          children: [
              IconButton(icon: const Icon(Icons.facebook, color: Colors.white, size: 24), onPressed: () {}),
              IconButton(icon: const Icon(Icons.ondemand_video, color: Colors.white, size: 24), onPressed: () {}), 
          ],
      );
  }

  Widget _buildFooter(BuildContext context) {
      final List<Map<String, String>> quickLinks = [
        {'label': 'Home / Beranda', 'route': '/'},
        {'label': 'Info Kampus', 'route': '/info'},
        {'label': 'Profil Mahasiswa', 'route': '/profile'},
        {'label': 'Peta Kampus', 'route': '/map'},
        {'label': 'KRS', 'route': '/krs'}, 
      ];

      return Container(
        color: const Color(0xFF001F3F), 
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/logo.png', height: 50, width: 50),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('UNIVERSITAS', style: TextStyle(color: Colors.white, fontSize: 14)),
                              Text('BHINNEKA TUNGGAL IKA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Mencetak Generasi Unggul untuk Indonesia Maju', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('HUBUNGI KAMI', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildContactRow(Icons.location_on, 'Jl. Persatuan No. 1, Jambi'),
                      _buildContactRow(Icons.phone, '(+62) 21 1234 5678'),
                      const SizedBox(height: 15),
                      const Text('IKUTI KAMI', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildSocialMediaRow(),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white54, height: 40),
            Center(
              child: Text(
                '© ${DateTime.now().year} Universitas Bhinneka Tunggal Ika. All Rights Reserved.',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            )
          ],
        ),
      );
  }

  Widget _buildDrawerContent(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.school, size: 40, color: Color(0xFF001F3F))),
                SizedBox(height: 10),
                Text('Portal Menu Akademik', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Akses Peta Kampus (/map)'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, '/map', arguments: 'Akses dari Drawer Profil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/'); 
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildDrawerContent(context),
      body: SingleChildScrollView(
        child: Column( 
          children: [ 
            // 1. HEADER PROFIL BARU
            _buildProfileHeader(context), 

            // 2. Konten Detail 
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form( // Gunakan Form untuk mengelola data yang diedit
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Detail Informasi
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildEditableField('NPM', Icons.person, _userData.npm, (val) => _userData.npm = val ?? _userData.npm),
                            const Divider(),
                            _buildEditableField('Email Kampus', Icons.email, _userData.email, (val) => _userData.email = val ?? _userData.email),
                            const Divider(),
                            _buildEditableField('Nomor HP', Icons.phone, _userData.phone, (val) => _userData.phone = val ?? _userData.phone),
                            const Divider(),
                            _buildEditableField('Dosen Wali', Icons.badge, _userData.dosenWali, (val) => _userData.dosenWali = val ?? _userData.dosenWali),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // Tombol Aksi Edit/Simpan
                    ElevatedButton.icon(
                      onPressed: _toggleEditing,
                      icon: Icon(_isEditing ? Icons.save : Icons.edit),
                      label: Text(_isEditing ? 'Simpan Perubahan' : 'Edit Data Profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEditing ? Colors.green.shade700 : Colors.blue.shade800, 
                        foregroundColor: Colors.white, 
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // 3. FOOTER
            _buildFooter(context), 
          ],
        ),
      ),
    );
  }
}