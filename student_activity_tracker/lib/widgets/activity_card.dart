// lib/widgets/activity_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import 'add_edit_activity_dialog.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // Kurangi padding horizontal
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: ListTile( // Gunakan ListTile untuk struktur
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        leading: Checkbox(
          value: activity.isCompleted,
          onChanged: (bool? newValue) {
            activity.isCompleted = newValue ?? false;
            provider.updateActivity(activity);
          },
          activeColor: Colors.teal,
          checkColor: Colors.white,
        ),
        title: Text(
          activity.title,
          style: TextStyle(
            decoration: activity.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            fontWeight: FontWeight.w600,
            color: activity.isCompleted ? Colors.grey : Colors.black87,
            fontSize: 16,
          ),
        ),
      subtitle: Text('${activity.type.toString().split('.').last.toUpperCase()} ${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // UPDATE (Edit Detail)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddEditActivityDialog(activity: activity),
            ),
          ),
          // DELETE
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
            onPressed: () => provider.deleteActivity(activity.id),
          ),
        ],
      ),
    ),
    );
  }
}