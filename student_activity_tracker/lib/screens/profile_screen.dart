// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/activity.dart'; 

class ProfileScreen extends StatefulWidget {
  final User currentUser;
  final Function(User) onUpdateUser;
  final List<Activity> activities;

  const ProfileScreen({
    super.key,
    required this.currentUser,
    required this.onUpdateUser,
    required this.activities,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State lokal untuk mengelola tampilan Edit/View
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  // Variabel untuk menyimpan data yang sedang diedit
  late String _editedName;
  late String _editedEmail;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data edit saat pertama kali dimuat
    _editedName = widget.currentUser.name;
    _editedEmail = widget.currentUser.email;
  }

  // Metode untuk menyimpan perubahan ke State global
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Membuat objek User baru dengan perubahan
      final updatedUser = widget.currentUser.copyWith(
        name: _editedName,
        email: _editedEmail,
        // Update avatar letter
        avatarLetter: _editedName.isEmpty ? '?' : _editedName[0].toUpperCase(),
      );
      
      widget.onUpdateUser(updatedUser); // Kirim data kembali ke HomeScreen
      
      setState(() {
        _isEditing = false; // Keluar dari mode edit
      });
    }
  }
  
  // --- Widget Pembantu Statistik ---

  double _calculateTotalHours() {
    return widget.activities.fold(0.0, (sum, item) => sum + item.duration);
  }

  // Widget Pembantu: Header Profil (Menggabungkan Nama dan Tombol Edit)
  Widget _buildProfileHeader(BuildContext context) {
    // Memastikan data selalu terbaru dari widget.currentUser
    final name = widget.currentUser.name;
    final initial = name.isNotEmpty ? name[0] : 'U';

    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: widget.currentUser.avatarColor,
          child: Text(
            initial,
            style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        
        // >>> BARIS KRITIS: Nama dan Tombol Edit Berdampingan <<<
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Ikon Edit hanya muncul dalam mode View
            if (!_isEditing)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 24),
                onPressed: () {
                  // Sinkronkan data saat masuk mode edit
                  _editedName = widget.currentUser.name;
                  _editedEmail = widget.currentUser.email;
                  setState(() {
                    _isEditing = true; // Masuk mode edit
                  });
                },
              ),
          ],
        ),
        // >>> AKHIR BARIS KRITIS <<<
        
        Text(
          widget.currentUser.email,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Widget Pembantu: Statistik Ringkasan
  Widget _buildStatsRow() {
    final totalHours = _calculateTotalHours();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total Log', widget.activities.length.toString(), Colors.blue),
        _buildStatItem('Total Hours', totalHours.toStringAsFixed(1), Colors.green),
        _buildStatItem('Best Streak', '14 Days', Colors.orange),
      ],
    );
  }
  
  // Widget Pembantu: Item Statistik Individual
  Widget _buildStatItem(String title, String value, Color color) {
    return Container(
      width: 100, 
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget Mode Tampilan (Hanya Display)
  Widget _buildViewMode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfileHeader(context),
        const SizedBox(height: 30),
        _buildStatsRow(),
        const SizedBox(height: 40),
        _buildSettingsSection(),
      ],
    );
  }
  
  // Widget Mode Edit (Form)
  Widget _buildEditForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header ditampilkan (tanpa ikon edit)
          _buildProfileHeader(context), 
          const SizedBox(height: 30),
          
          // Input Nama
          TextFormField(
            initialValue: widget.currentUser.name,
            decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong.' : null,
            onSaved: (value) => _editedName = value!,
          ),
          const SizedBox(height: 20),

          // Input Email
          TextFormField(
            initialValue: widget.currentUser.email,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value == null || !value.contains('@') ? 'Masukkan email yang valid.' : null,
            onSaved: (value) => _editedEmail = value!,
          ),
          const SizedBox(height: 30),

          // Tombol Cancel (dikembalikan ke mode View)
          TextButton(
            onPressed: () {
              setState(() => _isEditing = false);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // Widget Pembantu: Menu Pengaturan
  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('General Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        const Divider(),
        _buildSettingTile(Icons.notifications_none, 'Notifications', () {}),
        _buildSettingTile(Icons.palette_outlined, 'Appearance (Theme)', () {}),
        _buildSettingTile(Icons.lock_outline, 'Privacy & Security', () {}),
        _buildSettingTile(Icons.help_outline, 'Help & Support', () {}),
        const SizedBox(height: 20),
        _buildSettingTile(Icons.logout, 'Logout', () {}, color: Colors.red),
      ],
    );
  }

  // Widget Pembantu: Item Menu Pengaturan
  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue, size: 28),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color ?? Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }


  @override
  Widget build(BuildContext context) {
    // Sinkronisasi data edit (penting agar form selalu menampilkan data terbaru)
    if (_isEditing) {
      _editedName = widget.currentUser.name;
      _editedEmail = widget.currentUser.email;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol Save/Done hanya muncul di AppBar saat Editing
          if (_isEditing)
            TextButton(
              onPressed: _saveChanges,
              child: const Text('Save', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // Tampilkan Form jika _isEditing true, View jika false
        child: _isEditing ? _buildEditForm(context) : _buildViewMode(context),
      ),
    );
  }
}