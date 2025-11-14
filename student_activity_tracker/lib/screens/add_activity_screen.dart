// lib/screens/add_activity_screen.dart

import 'package:flutter/material.dart';
import 'dart:developer'; // Untuk mengganti print()
import '../models/activity.dart'; // Import Model

// Ubah menjadi StatefulWidget yang menerima callback
class AddActivityScreen extends StatefulWidget {
  final Function(Activity) onAddActivity;
  const AddActivityScreen({super.key, required this.onAddActivity});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _duration = 0.0;
  String _category = 'Studying'; 
  DateTime _date = DateTime.now();

  final List<String> _categories = ['Studying', 'Reading', 'Workout', 'Creative', 'Others'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _saveActivity() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final info = Activity.getCategoryInfo(_category);

      // 1. BUAT OBJEK ACTIVITY BARU
      final newActivity = Activity(
        title: _title,
        duration: _duration,
        category: _category,
        date: _date,
        color: info['color'] as Color,
        icon: info['icon'] as IconData,
      );

      // 2. KIRIM OBJEK BARU KEMBALI KE HOME SCREEN
      widget.onAddActivity(newActivity); 

      log('Aktivitas baru disimpan: Title: $_title, Category: $_category'); // Menggunakan log()

      // 3. TUTUP HALAMAN
      Navigator.pop(context); 

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity Logged Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('What did you work on?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),

              TextFormField(
                decoration: InputDecoration(labelText: 'Title / Subject', hintText: 'e.g., Studied Flutter Architecture', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.title)),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a title.' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 20),

              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Duration (Hours)', hintText: 'e.g., 2.5', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.timer)),
                validator: (value) => (value == null || double.tryParse(value) == null || double.parse(value) <= 0) ? 'Please enter a valid duration.' : null,
                onSaved: (value) => _duration = double.parse(value!),
              ),
              const SizedBox(height: 20),
              
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.category)),
                initialValue: _category,
                items: _categories.map((category) => DropdownMenuItem<String>(value: category, child: Text(category))).toList(),
                onChanged: (newValue) => setState(() => _category = newValue!),
                onSaved: (value) => _category = value!,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: Text('Date: ${_date.day}/${_date.month}/${_date.year}', style: const TextStyle(fontSize: 16))),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, color: Colors.blue),
                    label: const Text('Change Date', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Log Activity', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}