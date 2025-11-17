// lib/widgets/add_edit_activity_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';

class AddEditActivityDialog extends StatefulWidget {
  final Activity? activity; // Null jika CREATE, berisi data jika UPDATE

  const AddEditActivityDialog({this.activity, super.key});

  @override
  State<AddEditActivityDialog> createState() => _AddEditActivityDialogState();
}

class _AddEditActivityDialogState extends State<AddEditActivityDialog> {
  final _titleController = TextEditingController();
  late ActivityType _selectedType;
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      // MODE UPDATE
      _titleController.text = widget.activity!.title;
      _selectedType = widget.activity!.type;
      _selectedTime = widget.activity!.startTime;
    } else {
      // MODE CREATE
      _selectedType = ActivityType.routine;
      _selectedTime = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveActivity() {
    if (_titleController.text.isEmpty) return;

    final provider = Provider.of<ActivityProvider>(context, listen: false);

    if (widget.activity != null) {
      // UPDATE
      widget.activity!.title = _titleController.text;
      widget.activity!.type = _selectedType;
      widget.activity!.startTime = _selectedTime;
      // Asumsi endTime 1 jam setelah startTime (bisa disempurnakan)
      widget.activity!.endTime = _selectedTime.add(const Duration(hours: 1)); 
      provider.updateActivity(widget.activity!);
    } else {
      // CREATE
      final newActivity = Activity(
        title: _titleController.text,
        type: _selectedType,
        startTime: _selectedTime,
        // Asumsi endTime 1 jam setelah startTime
        endTime: _selectedTime.add(const Duration(hours: 1)),
      );
      provider.addActivity(newActivity);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.activity == null ? 'Tambah Aktivitas Baru' : 'Edit Aktivitas'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nama Aktivitas'),
            ),
            ListTile(
              title: const Text("Waktu Mulai"),
              trailing: TextButton(
                onPressed: () => _selectTime(context),
                child: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
              ),
            ),
            DropdownButton<ActivityType>(
              value: _selectedType,
              items: ActivityType.values.map((ActivityType type) {
                return DropdownMenuItem<ActivityType>(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (ActivityType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _saveActivity,
          child: Text(widget.activity == null ? 'SIMPAN' : 'UPDATE'),
        ),
      ],
    );
  }
}