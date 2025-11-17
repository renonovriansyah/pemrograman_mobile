import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';

class AddEditActivityDialog extends StatefulWidget {
  final Activity? activity;
  const AddEditActivityDialog({this.activity, super.key});

  @override
  State<AddEditActivityDialog> createState() => _AddEditActivityDialogState();
}

class _AddEditActivityDialogState extends State<AddEditActivityDialog> {
  final _titleController = TextEditingController();
  late ActivityType _selectedType;
  late DateTime _selectedStartTime;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _titleController.text = widget.activity!.title;
      _selectedType = widget.activity!.type;
      _selectedStartTime = widget.activity!.startTime;
    } else {
      _selectedType = ActivityType.routine;
      _selectedStartTime = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedStartTime),
    );
    if (picked != null) {
      setState(() {
        _selectedStartTime = DateTime(
          _selectedStartTime.year,
          _selectedStartTime.month,
          _selectedStartTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveActivity() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ActivityProvider>(context, listen: false);

      if (widget.activity != null) {
        widget.activity!.title = _titleController.text;
        widget.activity!.type = _selectedType;
        widget.activity!.startTime = _selectedStartTime;
        widget.activity!.endTime = _selectedStartTime.add(const Duration(hours: 1)); 
        provider.updateActivity(widget.activity!);
      } else {
        final newActivity = Activity(
          title: _titleController.text,
          type: _selectedType,
          startTime: _selectedStartTime,
          endTime: _selectedStartTime.add(const Duration(hours: 1)),
        );
        provider.addActivity(newActivity);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.activity == null ? 'Tambah Aktivitas' : 'Edit Aktivitas'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Aktivitas'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              ListTile(
                title: const Text("Waktu Mulai"),
                trailing: TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(DateFormat('HH:mm').format(_selectedStartTime)),
                ),
              ),
              DropdownButtonFormField<ActivityType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Tipe Aktivitas'),
                items: ActivityType.values.map((ActivityType type) {
                  return DropdownMenuItem<ActivityType>(
                    value: type,
                    child: Text(type.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (ActivityType? newValue) {
                  if (newValue != null) {
                    setState(() { _selectedType = newValue; });
                  }
                },
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
          onPressed: _saveActivity,
          child: Text(widget.activity == null ? 'SIMPAN' : 'UPDATE'),
        ),
      ],
    );
  }
}