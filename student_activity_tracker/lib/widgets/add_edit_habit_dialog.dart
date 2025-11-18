import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AddEditHabitDialog extends StatefulWidget {
  final Habit? habit;
  const AddEditHabitDialog({this.habit, super.key});

  @override
  State<AddEditHabitDialog> createState() => _AddEditHabitDialogState();
}

class _AddEditHabitDialogState extends State<AddEditHabitDialog> {
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _titleController.text = widget.habit!.title;
      _targetController.text = widget.habit!.targetAmount.toString();
      _unitController.text = widget.habit!.unit;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<HabitProvider>(context, listen: false);
      final title = _titleController.text;
      final target = int.tryParse(_targetController.text) ?? 0;
      final unit = _unitController.text;

      if (widget.habit != null) {
        widget.habit!.title = title;
        widget.habit!.targetAmount = target;
        widget.habit!.unit = unit;
        provider.incrementHabitProgress(widget.habit!.id, widget.habit!.currentAmount);
        
      } else {
        final newHabit = Habit(
          title: title,
          targetAmount: target,
          unit: unit,
          currentAmount: 0,
        );
        provider.addHabit(newHabit);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.habit == null ? 'Tambah Kebiasaan Baru' : 'Edit Kebiasaan'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Aktivitas Kebiasaan'),
                validator: (value) => value == null || value.isEmpty ? 'Belum diisi' : null,
              ),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Per Hari'),
                validator: (value) => value == null || int.tryParse(value) == null || int.tryParse(value)! <= 0
                    ? 'Masukkan Angka Target/Hari (> 0)'
                    : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Satuan'),
                validator: (value) => value == null || value.isEmpty ? 'Belum Diisi, Contoh: Kali' : null,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _saveHabit,
          child: Text(widget.habit == null ? 'SIMPAN' : 'UPDATE'),
        ),
      ],
    );
  }
}