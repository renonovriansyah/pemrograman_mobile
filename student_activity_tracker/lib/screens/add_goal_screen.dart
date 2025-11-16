// lib/screens/add_goal_screen.dart

import 'package:flutter/material.dart';
import '../models/goal.dart';

// --- Data Kategori untuk Goal (Dapat disesuaikan) ---
final Map<String, Map<String, dynamic>> goalCategories = {
  'Studying': {'icon': Icons.book, 'color': const Color(0xFF42A5F5)},
  'Workout': {'icon': Icons.directions_run, 'color': const Color(0xFF66BB6A)},
  'Reading': {'icon': Icons.menu_book, 'color': const Color(0xFFE64A19)},
  'Hobby': {'icon': Icons.palette, 'color': const Color(0xFFFFC107)},
  'Other': {'icon': Icons.more_horiz, 'color': Colors.grey},
};

class AddGoalScreen extends StatefulWidget {
  // Callback untuk mengirim Goal baru kembali ke HomeScreen
  final Function(Goal) onAddGoal; 

  const AddGoalScreen({super.key, required this.onAddGoal});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  // Set default category
  String _selectedCategory = goalCategories.keys.first; 
  double _targetHours = 0.0;

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final categoryDetails = goalCategories[_selectedCategory]!;

      // Buat objek Goal baru
      final newGoal = Goal(
        title: _title,
        category: _selectedCategory,
        targetHours: _targetHours,
        color: categoryDetails['color'],
        icon: categoryDetails['icon'],
      );

      // Kirim Goal baru melalui callback
      widget.onAddGoal(newGoal);
      Navigator.pop(context); // Kembali ke halaman sebelumnya (GoalsScreen)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Goal', style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text('What is your new goal?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),

              // 1. Goal Title Input (Sinkron)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  hintText: 'e.g., Focus on Flutter Architecture',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Masukkan judul goal.' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 20),

              // 2. Target Hours Input (Sinkron)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Target Hours per Week',
                  hintText: 'e.g., 15.0',
                  suffixText: 'hours',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.flag),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Masukkan target jam yang valid (> 0).';
                  }
                  return null;
                },
                onSaved: (value) => _targetHours = double.parse(value!),
              ),
              const SizedBox(height: 20),

              const Text('Select Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // 3. Category Selection (Chips Sinkron dengan gaya Quick Log)
              Wrap(
                spacing: 10.0,
                children: goalCategories.keys.map((category) {
                  final details = goalCategories[category]!;
                  final isSelected = _selectedCategory == category;
                  
                  return ChoiceChip(
                    label: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    selectedColor: details['color'].withOpacity(0.8),
                    backgroundColor: Colors.grey.shade100, // Latar belakang netral
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: isSelected ? details['color'] : Colors.grey.shade300, width: 1.5),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // 4. Save Button (Sinkron)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Save Goal', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}