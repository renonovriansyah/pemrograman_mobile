import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import 'add_edit_habit_dialog.dart'; // Import dialog edit

class HabitCard extends StatelessWidget {
  final Habit habit;
  const HabitCard({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context, listen: false);
    double percent = habit.currentAmount / habit.targetAmount;
    if (percent > 1.0) percent = 1.0;

    return InkWell(
      onLongPress: () {
        // Opsi edit/hapus
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blueGrey),
                  title: const Text('Edit Detail Kebiasaan'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AddEditHabitDialog(habit: habit),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus Kebiasaan'),
                  onTap: () {
                    provider.deleteHabit(habit.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              animation: true,
              percent: percent,
              center: Text(
                "${(percent * 100).toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.teal),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.teal,
              backgroundColor: Colors.teal.shade50,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                habit.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${habit.currentAmount}/${habit.targetAmount} ${habit.unit}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                // Tombol untuk menambah progres
                InkWell(
                  onTap: () {
                    int newAmount = habit.currentAmount + (habit.unit == 'ml' ? 100 : 1);
                    provider.updateHabitProgress(habit.id, newAmount);
                  },
                  child: const FaIcon(FontAwesomeIcons.circlePlus, color: Colors.green, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}