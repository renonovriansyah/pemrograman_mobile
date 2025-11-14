// lib/screens/add_activity_screen.dart

import 'package:flutter/material.dart';
import 'dart:developer';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  // State untuk menyimpan input form
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _duration = 0.0;
  String _category = 'Studying'; // Nilai default
  DateTime _date = DateTime.now();

  // Opsi kategori yang sinkron dengan ikon Quick Log
  final List<String> _categories = [
    'Studying', 
    'Reading', 
    'Workout', 
    'Creative', 
    'Others'
  ];

  // Metode untuk memilih tanggal
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

  // Metode untuk menyimpan data (simulasi)
  void _saveActivity() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // --- Logika Penyimpanan Data (SIMULASI) ---
      log('--- Logika Penyimpanan Data (SIMULASI) ---');
      log('Aktivitas baru disimpan:');
      log('  Title: $_title');
      log('  Duration: $_duration h');
      log('  Category: $_category');
      log('  Date: ${_date.toIso8601String().split('T').first}');
      
      // Kembali ke halaman sebelumnya (Home Screen)
      Navigator.pop(context); 

      // Tampilkan notifikasi
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

              // --- Input Title ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title / Subject',
                  hintText: 'e.g., Studied Flutter Architecture',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 20),

              // --- Input Duration ---
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Duration (Hours)',
                  hintText: 'e.g., 2.5',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid duration.';
                  }
                  return null;
                },
                onSaved: (value) => _duration = double.parse(value!),
              ),
              const SizedBox(height: 20),
              
              // --- Input Category (Dropdown) ---
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.category),
                ),
                initialValue: _category,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                onSaved: (value) => _category = value!,
              ),
              const SizedBox(height: 20),

              // --- Input Date ---
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_date.day}/${_date.month}/${_date.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, color: Colors.blue),
                    label: const Text('Change Date', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- Submit Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Log Activity',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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