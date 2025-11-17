import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // 1. Checkbox
          Checkbox(
            value: activity.isCompleted,
            onChanged: (bool? newValue) {
              activity.isCompleted = newValue ?? false;
              provider.updateActivity(activity);
            },
            activeColor: Colors.teal,
            checkColor: Colors.white,
          ),
          
          // 2. Icon Tipe Tugas (Menggantikan Icon di Mockup)
          FaIcon(
            _getIconForType(activity.type),
            size: 16,
            color: provider.getColorForType(activity.type),
          ),
          const SizedBox(width: 12),

          // 3. Title dan Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    decoration: activity.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    color: activity.isCompleted ? Colors.grey : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${activity.type.toString().split('.').last.toUpperCase()} | ${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
          
          // 4. Trailing Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit Detail
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.solidClock, color: Colors.blueGrey, size: 16),
                onPressed: () { /* Tambahkan logika Ubah Waktu di sini */ },
              ),
              // Delete
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.trash, color: Colors.redAccent, size: 16),
                onPressed: () => provider.deleteActivity(activity.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.call:
        return FontAwesomeIcons.phone;
      case ActivityType.deepWork:
        return FontAwesomeIcons.laptopCode;
      case ActivityType.workout:
        return FontAwesomeIcons.dumbbell;
      case ActivityType.routine:
        return FontAwesomeIcons.listCheck;
    }
  }
}