import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade800),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      trailing: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  // --- WIDGET PEMBANTU FOOTER ---
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
              IconButton(icon: const Icon(Icons.share, color: Colors.white, size: 24), onPressed: () {}), 
              IconButton(icon: const Icon(Icons.ondemand_video, color: Colors.white, size: 24), onPressed: () {}), 
          ],
      );
  }
  
  // --- WIDGET FOOTER UTAMA ---
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
                      const Text('TAUTAN CEPAT', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...quickLinks.map((link) => Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(link['label']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          )),
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
        title: const Text('Profil Mahasiswa'),
      ),
      drawer: _buildDrawerContent(context),
      body: SingleChildScrollView(
        child: Column( 
          children: [ 
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                    Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(15)),
                          ),
                          const Column(
                            children: [
                              CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'), backgroundColor: Colors.white),
                              SizedBox(height: 10),
                              Text('John Doe (Mahasiswa Aktif)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              Text('Teknik Informatika - Angkatan 2021', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                    ),
                    const SizedBox(height: 30),
                    Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildProfileTile(Icons.person, 'NPM', '20210001'),
                              const Divider(),
                              _buildProfileTile(Icons.email, 'Email Kampus', 'john.doe@campus.ac.id'),
                              const Divider(),
                              _buildProfileTile(Icons.phone, 'Nomor HP', '0812-3456-7890'),
                              const Divider(),
                              _buildProfileTile(Icons.badge, 'Dosen Wali', 'Dr. Budi Santoso, M.Kom'),
                            ],
                          ),
                        ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                        onPressed: () { /* Aksi Edit */ },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Data Profil'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    ),
                ],
              ),
            ),
            
            _buildFooter(context), 
          ],
        ),
      ),
    );
  }
}