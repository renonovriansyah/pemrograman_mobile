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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Profil
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'John Doe (Mahasiswa Aktif)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text('Teknik Informatika - Angkatan 2021', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // Detail Informasi
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

            // Tombol Aksi
            ElevatedButton.icon(
              onPressed: () { /* Aksi Edit */ },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Data Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}